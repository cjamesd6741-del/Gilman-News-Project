import 'package:flutter/material.dart';
import 'package:apitest_2/services/stats/Articlestorage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:apitest_2/services/cardclass.dart';
import 'package:apitest_2/services/cardbuilder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  bool _isRouteVisible = false;
  bool _isTabVisible = false;
  late Future<List> followed_authors;
  late Future<List<FollowCardclass>> finalcards;
  Storedata storedata = Storedata();

  @override
  void initState() {
    super.initState();
    followed_authors = storedata.followed_author_reader();
    finalcards = followed_articles_updater();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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

  void onTabVisible() {
    Future<List> authors = followed_authors;
    followed_authors = storedata.followed_author_reader();
    if (authors != followed_authors) {
      setState(() {
        finalcards = followed_articles_updater();
      });
    }
  }

  Future<List<FollowCardclass>> followed_articles_updater() async {
    final authors = await followed_authors;
    if (authors.isNotEmpty) {
      final data = await Supabase.instance.client.rpc(
        'follow_author_gen',
        params: {'followed_list': authors},
      );
      debugPrint('data loaded');
      List finaldata = data;
      List<FollowCardclass> cards = finaldata
          .map(
            (e) => FollowCardclass(
              articleTitle: e["Article_Title"],
              author: e["Author"],
              date: e["Date"],
              edition_num: e["edition_num"],
            ),
          )
          .toList();
      cards.shuffle();
      cards.sort((a, b) {
        return b.edition_num.compareTo(a.edition_num);
      });
      return cards;
    } else
      return [];
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
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
      body: Container(
        color: const Color.fromARGB(255, 158, 175, 206),
        child: FutureBuilder<List<FollowCardclass>>(
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

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return FollowCardbuild(followcardclass: data[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
