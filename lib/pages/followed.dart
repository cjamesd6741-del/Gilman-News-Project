import 'package:flutter/material.dart';
import 'package:apitest_2/services/stats/Articlestorage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:apitest_2/services/cardclass.dart';
import 'package:apitest_2/services/cardbuilder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:apitest_2/services/cache.dart';
import 'package:apitest_2/services/globals.dart';

class Followed_Page extends StatefulWidget {
  final int tab_index;
  final RouteObserver<ModalRoute<void>> observer;
  const Followed_Page({
    super.key,
    required this.observer,
    required this.tab_index,
  });

  @override
  State<Followed_Page> createState() => Followed_PageState();
}

class Followed_PageState extends State<Followed_Page> with RouteAware {
  CacheManager cacheManager = CacheManager();
  bool _isRouteVisible = false;
  bool _isTabVisible = false;
  late Future<List> followed_authors;
  late Future<List<Article>> finalcards;
  late List<ArticleWithReadStatus> processedArticles;
  late Set<int> readarticles;
  Storedata storedata = Storedata();
  double width = 600;

  @override
  void initState() {
    super.initState();
    final cached = cacheManager.get("read_articles") ?? [];
    readarticles = Set<int>.from(cached);
    followed_authors = storedata.followed_author_reader();
    finalcards = datagenerator();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      width = MediaQuery.of(context).size.width;
    });
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      widget.observer.subscribe(this, route);
    }
  }

  void _checkIfShouldRefresh() {
    if (_isRouteVisible && _isTabVisible) {
      onTabVisible();
    }
  }

  @override
  void dispose() {
    widget.observer.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _isRouteVisible = true;
    _checkIfShouldRefresh();
  }

  @override
  void didPopNext() {
    _isRouteVisible = true;
    _checkIfShouldRefresh();
  }

  @override
  void didPushNext() {
    _isRouteVisible = false;
    _checkIfShouldRefresh();
  }

  @override
  void didPop() {
    _isRouteVisible = false;
    _checkIfShouldRefresh();
  }

  void onTabVisibilityChanged(bool visible) {
    if (_isTabVisible == visible) return; // only act if state changes
    _isTabVisible = visible;

    if (visible) {
      _checkIfShouldRefresh();
    }
  }

  void refreshPage() async {
    final cached = await cacheManager.get("read_articles") ?? [];
    readarticles = Set<int>.from(cached);
    setState(() {
      width = MediaQuery.of(context).size.width;
      finalcards = datagenerator(); // 🔥 refetch data
    });
  }

  void onTabVisible() {
    followed_authors = storedata.followed_author_reader();
    refreshPage();
  }

  Future<List<Article>> datagenerator() async {
    final authors = await followed_authors;
    if (authors.isNotEmpty) {
      if (Globals.followed_changed == false) {
        debugPrint("local call");
        final data = cacheManager.get("followed_articles") ?? [];
        List finaldata = data;
        List<Article> cards = finaldata
            .map(
              (e) => Article(
                Article_Title: e["Article_Title"],
                author: e["Author"],
                Date: e["Date"],
                edition_num: e["edition_num"],
                Article_ID: e["Article_ID"],
              ),
            )
            .toList();
        cards.sort((a, b) {
          return b.edition_num.compareTo(a.edition_num);
        });
        return cards;
      }
      final data = await Supabase.instance.client.rpc(
        'follow_author_gen',
        params: {'followed_list': authors},
      );
      List finaldata = data;
      cacheManager.save("followed_articles", data);
      List<Article> cards = finaldata
          .map(
            (e) => Article(
              Article_Title: e["Article_Title"],
              author: e["Author"],
              Date: e["Date"],
              edition_num: e["edition_num"],
              Article_ID: e["Article_ID"],
            ),
          )
          .toList();
      cards.sort((a, b) {
        return b.edition_num.compareTo(a.edition_num);
      });
      Globals.followed_changed = false;
      debugPrint("supabase_call");
      return cards;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            forceElevated: true,
            shadowColor: Colors.black,
            elevation: 4.0,
            backgroundColor: const Color.fromARGB(255, 34, 72, 92),
            expandedHeight: 140,
            collapsedHeight: 80,
            pinned: true,
            flexibleSpace: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'lib/images/Followed_Authors.jpeg',
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: double.infinity,
                    height: double.infinity,
                    color: innerBoxIsScrolled
                        ? const Color.fromARGB(255, 34, 72, 92)
                        : Colors.transparent,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Followed Author',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Articles',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(3),
              child: Container(
                color: const Color.fromARGB(255, 31, 30, 46),
                height: 3,
              ),
            ),
          ),
        ];
      },
      body: Center(
        child: Container(
          color: const Color.fromARGB(255, 158, 175, 206),
          child: FutureBuilder<List<Article>>(
            future: finalcards,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SpinKitCubeGrid(size: 100, color: Colors.blueGrey),
                );
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final data = snapshot.data ?? [];
              if (data.isEmpty) {
                return const Center(child: Text('No followed articles'));
              }
              processedArticles = data.map((article) {
                return ArticleWithReadStatus(
                  article: article,
                  isRead: readarticles.contains(article.Article_ID),
                );
              }).toList();
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: processedArticles.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // <-- centers the card
                    children: [
                      SizedBox(
                        width: width * .95,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 10),
                          child: CurrentCardbuild(
                            article: processedArticles[index],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
