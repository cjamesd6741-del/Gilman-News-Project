import 'package:apitest_2/services/followed_author_widget.dart';
import 'package:flutter/material.dart';
import '/services/stats/Articlestorage.dart';
import '/services/stats/algorithm.dart';
import 'package:apitest_2/services/routes.dart';

class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  State<Stats> createState() => StatsState();
}

class StatsState extends State<Stats> with RouteAware {
  final listKey = GlobalKey<AnimatedListState>();
  int articlesRead = 0;
  Duration duration = Duration.zero;
  Duration shownduration = Duration.zero;
  int articler = 0;
  Storedata storedata = Storedata();
  Topthree topthree = Topthree();
  List<Category> topthreecategorieslist = [];
  List<Category> recentcategorieslist = [];
  List<Author> topthreeauthorslist = [];
  List followed_authors = [];
  bool follow_loaded = false;
  bool _isTabVisible = false;

  Future getdata() async {
    follow_loaded = false;
    articlesRead = await storedata.numarticleread();
    duration = await storedata.durationreader();
    topthreecategorieslist = await topthree.gettopthreecategories();
    recentcategorieslist = await topthree.gettopthreerecentcategories();
    topthreeauthorslist = await topthree.gettopthreeauthors();
    followed_authors = await storedata.followed_author_reader();
    setState(() {
      articler = articlesRead;
      shownduration = Duration(seconds: duration.inSeconds);
      topthreecategorieslist = topthreecategorieslist;
      recentcategorieslist = recentcategorieslist;
      topthreeauthorslist = topthreeauthorslist;
      followed_authors = followed_authors;
      follow_loaded = true;
    });
  }

  @override
  initState() {
    super.initState();
    getdata();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  void onTabVisibilityChanged(bool visible) {
    if (_isTabVisible == visible) return; // only act if state changes
    _isTabVisible = visible;

    if (visible) {
      onTabVisible();
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    onTabVisible();
  }

  @override
  void didPopNext() {
    onTabVisible();
  }

  void onTabVisible() async {
    await getdata();
    debugPrint('test');
  }

  void removeItem(int index) {
    final removedauthor = followed_authors[index];
    storedata.remove_new_followed_author(removedauthor);
    followed_authors.removeAt(index);
    listKey.currentState!.removeItem(
      index,
      (context, animation) => Followed_Author_Card(
        item: removedauthor,
        animation: animation,
        onClicked: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 55, 109, 138),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              centerTitle: true,
              backgroundColor: const Color.fromARGB(255, 34, 72, 92),
              title: const Text(
                'Your Stats',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 216, 214, 214),
                ),
              ),
              floating: true,
              forceElevated: innerBoxIsScrolled,
              expandedHeight: 100,
              collapsedHeight: 80,
            ),
          ];
        },
        body: Center(
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    'Articles Read: $articler',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Reading Duration: $shownduration',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Top Categories:',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 255, 249, 249),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: topthreecategorieslist.length,
                    itemBuilder: (context, index) {
                      return CategoryCard(
                        category: topthreecategorieslist[index],
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Top Recent Categories:',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 255, 249, 249),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recentcategorieslist.length,
                    itemBuilder: (context, index) {
                      return CategoryCard(
                        category: recentcategorieslist[index],
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Favorite Writers',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 255, 249, 249),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: topthreeauthorslist.length,
                    itemBuilder: (context, index) {
                      return AuthorCard(author: topthreeauthorslist[index]);
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      storedata.clearData.clear();
                      getdata();
                    },
                    child: Text("clear all data"),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      "Followed Authors",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 255, 249, 249),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (follow_loaded)
                    SizedBox(
                      height: 300,
                      child: AnimatedList(
                        shrinkWrap: true,
                        key: listKey,
                        initialItemCount: followed_authors.length,
                        itemBuilder: (context, index, animation) =>
                            Followed_Author_Card(
                              item: followed_authors[index],
                              animation: AlwaysStoppedAnimation(1.0),
                              onClicked: () => removeItem(index),
                            ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
