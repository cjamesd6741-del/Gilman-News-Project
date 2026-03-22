import 'package:apitest_2/services/cache.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/cardbuilder.dart';
import '../services/cardclass.dart';
import '../pages/articlesearch.dart';
import 'package:apitest_2/services/globals.dart';

class AllArticlesPage extends StatefulWidget {
  final int tab_index;
  final RouteObserver<ModalRoute<void>> observer;
  const AllArticlesPage({
    super.key,
    required this.tab_index,
    required this.observer,
  });
  @override
  State<AllArticlesPage> createState() => AllArticlesPageState();
}

class AllArticlesPageState extends State<AllArticlesPage> with RouteAware {
  List<Article> articles = [];
  CacheManager cacheManager = CacheManager();
  late List<ArticleWithReadStatus> processedArticles;
  late Set readarticles;
  List<Article> articlelist = [];
  late int version_num = cacheManager.get('article_version_number') ?? 0;
  late Future _future;
  bool _isRouteVisible = false; // is on current tab?
  bool _isTabVisible = false; // is on current screen?
  ValueNotifier<Set<int>> readArticlesNotifier = ValueNotifier({});

  @override // all are checks to see if visibility changes
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
  }

  @override
  void didPop() {
    _isRouteVisible = false;
  }

  void onTabVisibilityChanged(bool visible) {
    if (_isTabVisible == visible) return; // only act if state changes
    _isTabVisible = visible;

    if (visible) {
      _checkIfShouldRefresh();
    }
  }

  void _checkIfShouldRefresh() {
    if (_isTabVisible) {
      onTabVisible();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      widget.observer.subscribe(this, route);
    }
  }

  @override
  initState() {
    super.initState();
    final cached = cacheManager.get("read_articles") ?? [];
    readArticlesNotifier = ValueNotifier(Set<int>.from(cached));
    readarticles = cached.toSet();
    _future = datagenerator();
  }

  void onTabVisible() {
    debugPrint("hello");
    refreshPage();
  }

  Future<List> datagenerator() async {
    version_num = await cacheManager.get('article_version_number') ?? 0;
    var online_version_number = await Supabase.instance.client
        .from('Version_Numbers')
        .select('Table_Name, Version')
        .eq('Table_Name,', 'Articles')
        .single();
    if (online_version_number['Version'] != version_num) {
      return getdata(online_version_number['Version']);
    }
    return Future.value(cacheManager.get('article_cards'));
  }

  Future<List> getdata(int vnum) async {
    var data = await Supabase
        .instance
        .client // queries supabase for data
        .from('Articles')
        .select('Author, Article_Title, Date, Article_ID, edition_num');
    cacheManager.save('article_version_number', vnum);
    cacheManager.save('article_cards', data);
    return data;
  }

  void refreshPage() async {
    debugPrint('called');
    final cached = await cacheManager.get("read_articles") ?? [];
    readarticles = cached.toSet();
    Globals.globalReadArticlesNotifier.value = Set<int>.from(cached);
    setState(() {
      _future = datagenerator();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 158, 175, 206),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              // top bar
              forceElevated: true,
              shadowColor: Colors.black,
              elevation: 4.0,
              backgroundColor: const Color.fromARGB(255, 34, 72, 92),
              expandedHeight: 180,
              collapsedHeight: 90,
              pinned: true,
              floating: true,
              flexibleSpace: Stack(
                children: [
                  FlexibleSpaceBar(
                    background: Image.asset(
                      'lib/images/IMG_0425.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    // stacked widgets that become transparent to let widgets below them show when inner box is not scrolled
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
                            children: [
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 100),
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: innerBoxIsScrolled
                                      ? Colors.white
                                      : Color.fromARGB(255, 34, 72, 92),
                                ),

                                child: Text('Gilman News'),
                              ),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 100),
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: innerBoxIsScrolled
                                      ? Colors.white
                                      : Color.fromARGB(255, 34, 72, 92),
                                ),
                                child: Text('All Articles'),
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
        body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final List instruments = snapshot.data as List;
            articlelist = instruments.map((article) {
              return Article(
                Article_ID: article['Article_ID'],
                Article_Title: article['Article_Title'],
                author: article['Author'],
                Date: article['Date'],
                edition_num: article["edition_num"] ?? 0.0,
              );
            }).toList();

            // articles = instruments.map<Article>((instrument) {
            //   return Article(
            //     Article_Title: instrument['Article_Title'],
            //     author: instrument['Author'],
            //     Date: instrument['Date'],
            //     edition_num: instrument['edition_num'],
            //     Article_ID: instrument["Article_ID"]
            //   );
            // }).toList();
            processedArticles = articlelist.map((article) {
              return ArticleWithReadStatus(
                article: article,
                isRead: readarticles.contains(article.Article_ID),
              );
            }).toList();

            return ListView.builder(
              // called instrument because I originally used tutorial to build this page
              itemCount: instruments.length + 1,
              itemBuilder: ((context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: AllArticleSearch(
                              articles: processedArticles,
                              readnotifier: Globals.globalReadArticlesNotifier,
                            ), //not even remotely confusing lol
                          );
                        },
                        icon: Icon(Icons.search_rounded, color: Colors.black),
                      ),
                    ),
                  );
                } // End of index button\
                final instrument = processedArticles[index - 1];
                return ListTile(title: CurrentCardbuild(article: instrument));
              }),
            );
          },
        ),
      ),
    );
  }
}
