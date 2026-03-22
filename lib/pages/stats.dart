import 'package:apitest_2/services/followed_author_widget.dart';
import 'package:flutter/material.dart';
import '../services/stats/articlestorage.dart';
import '/services/stats/algorithm.dart';
import 'package:apitest_2/services/routes.dart';
import 'package:google_fonts/google_fonts.dart';

class Stats extends StatefulWidget {
  final int tab_index;
  final RouteObserver<ModalRoute<void>> observer;
  const Stats({super.key, required this.observer, required this.tab_index});

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
      backgroundColor: const Color.fromARGB(255, 190, 200, 206),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              forceElevated: true,
              shadowColor: Colors.black,
              elevation: 4.0,
              backgroundColor: const Color.fromARGB(255, 34, 72, 92),
              expandedHeight: 180,
              collapsedHeight: 80,
              pinned: true,
              flexibleSpace: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('lib/images/Stats.png', fit: BoxFit.cover),
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
                          child: Center(
                            child: Text(
                              'Stats',
                              style: GoogleFonts.lora(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
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
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    'Articles Read: $articler',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 0, 75, 141),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Reading Duration:',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 0, 75, 141),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Hours : ${shownduration.inHours} , Minutes : ${shownduration.inMinutes.remainder(60)}, Seconds : ${shownduration.inSeconds.remainder(60)}',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 0, 75, 141),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Top Categories:',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 0, 75, 141),
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
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 0, 75, 141),
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
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 0, 75, 141),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 34, 72, 92),
                      foregroundColor: Colors.white,
                      elevation: 3,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 0, 75, 141),
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
