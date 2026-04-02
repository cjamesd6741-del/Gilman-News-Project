import 'dart:collection';
import 'package:google_fonts/google_fonts.dart';
import 'package:apitest_2/services/following_system.dart';
import '/services/similarity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '/services/stats/Articlestorage.dart';
import '/services/appbartext.dart';
import '/services/back_from_rec.dart';
import 'package:apitest_2/services/cache.dart';
import 'package:apitest_2/services/globals.dart';
import '../services/cardclass.dart';
import 'package:apitest_2/services/cardbuilder.dart';

class Article_Page extends StatefulWidget {
  // shows the actual article
  final int tab_index;
  final RouteObserver<ModalRoute<void>> observer;
  const Article_Page({
    super.key,
    required this.tab_index,
    required this.observer,
  });

  @override
  State<Article_Page> createState() => Article_PageState();
}

class Article_PageState extends State<Article_Page> with RouteAware {
  CacheManager cacheManager = CacheManager();
  bool _isRouteVisible = false; // is on current tab?
  bool _isTabVisible = false; // is on current screen?
  Storedata storedata = Storedata(); // class for data storage
  Textconfigure textconfigure = Textconfigure();
  TextStyle appbartextStyle = const TextStyle(
    fontSize: 18,
    height: 1.2,
    color: Color.fromARGB(255, 25, 38, 56),
  );
  bool firstbuild = true;
  List categories = [];
  Stopwatch stopwatch = Stopwatch();
  List authorslist = [];
  String authors = '';
  Similarity_Finder similar = Similarity_Finder();
  int id = 0;
  late Future<List<Article>> recs;
  bool _initialized = false;
  String prevauthor = ''; // init
  String prevtitle = ''; // init
  bool recommended =
      false; //note this variable is only used to determine if the current article was pushed by an recommend button, in which case we create a way for the reader to go back
  Map data = {};
  late Future followed_authors;
  late List<ArticleWithReadStatus> processedArticles;
  late Set readarticles;

  @override
  initState() {
    super.initState();
    final cached = cacheManager.get("read_articles") ?? []; //gets read articles
    readarticles = cached.toSet();
    followed_authors = storedata
        .followed_author_reader(); // gets followed authors
    storedata.updatearticleread(); // +1 to articles read
    stopwatch.start();
    firstbuild = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map) {
        categories = args['category'] ?? [];
        storedata.categorywriter(categories); // updates categories
        storedata.past10update(ListQueue.from(categories)); // updates recents
        if (args['recommended'] == true) {
          setState(() {
            recommended = true;
            prevauthor = args['prevauthor'];
            prevtitle = args['prevtitle'];
          });
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      widget.observer.subscribe(this, route);
    }
    if (!_initialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map) {
        data = args;
        categories = args['category'] ?? []; // redundant but idk
        authors = args['author'];
        authorslist = authors.split(RegExp(r',\s*|\s+and\s+'));
        storedata.authorwriter(authorslist); // writes authors to data
        id = args['id'];
        recs = similar.getsimilarcategories(
          id,
          authors,
          args['title'],
        ); // builds recommend cards
        register_article();
      }
      _initialized = true; // ensures only called once per lifecycle
    }
  }

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
    if (_isRouteVisible && _isTabVisible) {
      onTabVisible();
    }
  }

  void onLeave() {
    stopwatch.stop();
    storedata.durationupdate(stopwatch.elapsed);
    firstbuild = false;
  } // adds duration to data

  void onTabVisible() async {
    final cached =
        await cacheManager.get("read_articles") ?? []; //gets read articles
    // just updates follow button and now recs
    setState(() {
      followed_authors = storedata.followed_author_reader();
      readarticles = cached.toSet();
    });
  }

  void register_article() async {
    List articles = await cacheManager.get("read_articles") ?? [];
    if (articles.contains(id)) {
    } else {
      articles.add(id);
      await cacheManager.save("read_articles", articles);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map) {
      data = args;
    } else {
      return SpinKitCircle(
        color: const Color.fromARGB(255, 23, 69, 107),
        size: 50.0,
      );
    }
    final textStyle = appbartextStyle;
    final width = MediaQuery.of(context).size.width - 72;
    final double height = textconfigure.textHeight(
      width,
      data['title'] ?? 'Article',
      textStyle,
    );
    if (firstbuild == true) {
      categories = data['category'] ?? [];
      if (categories.isNotEmpty) {}
    }
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          onLeave();
        }
      },
      child: InteractiveViewer(
        // interactive viewer kind of works but struggles with scrollview
        panEnabled: false,
        minScale: 1,
        maxScale: 3,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 218, 222, 226),
          // actual layout
          appBar: AppBar(
            elevation: 10,
            shadowColor: Colors.black,
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            toolbarHeight: height + 50,
            actions: [
              if (recommended == true)
                RecommendCard(
                  // previous sreen button
                  back_from_rec: Back_From_Rec(
                    author: prevauthor,
                    title: prevtitle,
                  ),
                ),
            ],
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data['title'] ?? 'Article',
                  softWrap: true,
                  maxLines: null,
                  overflow: TextOverflow.visible,
                  style: appbartextStyle, // TODO : update appbar
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 16.0, 30.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  if (data['image_urls'] != null &&
                      (data['image_urls'] as List).length > 1)
                    SafeArea(
                      left: true,
                      right: true,
                      child: ClipRect(
                        child: CarouselSlider(
                          // TODO: add dots or somth on bottom of carousel to show number of photos and user position
                          options: CarouselOptions(
                            viewportFraction:
                                .95, // TODO: find a way to make this smaller with out causing overflow error
                            height: 500,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: true,
                            autoPlay: false,
                            clipBehavior: Clip.hardEdge,
                          ),
                          items: List.generate((data['image_urls'] as List).length, (
                            index,
                          ) {
                            final url = data['image_urls'][index];
                            final labels = data['image_labels'] as List?;
                            return Column(
                              children: [
                                if (labels != null &&
                                    index < labels.length) ...[
                                  Text(
                                    labels[index] ?? "",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],

                                Container(
                                  child: Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                    height: 350,
                                    frameBuilder:
                                        (
                                          context,
                                          child,
                                          frame,
                                          wasSynchronouslyLoaded,
                                        ) {
                                          if (frame == null) {
                                            return Container(
                                              height: 350,
                                              child: const Center(
                                                child: SizedBox(
                                                  height: 100,
                                                  width: 100,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 10,
                                                        color: Color.fromARGB(
                                                          255,
                                                          9,
                                                          8,
                                                          50,
                                                        ),
                                                      ),
                                                ),
                                              ),
                                            );
                                          }
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: const Color.fromARGB(
                                                    255,
                                                    9,
                                                    8,
                                                    50,
                                                  ),
                                                  width: 5,
                                                ),
                                              ),
                                              child: child,
                                            ),
                                          );
                                        },
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }

                                      return Container(
                                        height: 350,
                                        child: Center(
                                          child: SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 10,
                                              color: const Color.fromARGB(
                                                255,
                                                9,
                                                8,
                                                50,
                                              ),
                                              value:
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ), // if there are multiple images, show a carousel
                  if (data['image_urls'] != null &&
                      (data['image_urls'] as List).length == 1) // one image
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Image.network(
                              data['image_urls'][0],
                              fit: BoxFit.cover,
                              frameBuilder:
                                  (
                                    context,
                                    child,
                                    frame,
                                    wasSynchronouslyLoaded,
                                  ) {
                                    if (frame == null) {
                                      return Container(
                                        height: 350,
                                        child: const Center(
                                          child: SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 10,
                                              color: Color.fromARGB(
                                                255,
                                                9,
                                                8,
                                                50,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                              255,
                                              9,
                                              8,
                                              50,
                                            ),
                                            width: 5,
                                          ),
                                        ),
                                        child: child,
                                      ),
                                    );
                                  },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null)
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color.fromARGB(
                                                255,
                                                9,
                                                8,
                                                50,
                                              ),
                                              width: 5,
                                            ),
                                          ),
                                          child: child,
                                        ),
                                      );

                                    return Center(
                                      child: SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 10,
                                          color: Color.fromARGB(
                                            255,
                                            0,
                                            75,
                                            141,
                                          ),
                                          value:
                                              loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                            ),
                          ),
                        ),
                        if (data['image_labels'] != null &&
                            (data['image_labels'] as List).isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              data['image_labels'][0],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ], // TODO: add way to zoom into images
                    ),
                  Text(
                    'Authors:',
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder(
                    future: followed_authors,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return SpinKitChasingDots(
                          size: 75,
                          color: const Color.fromARGB(255, 2, 4, 88),
                        );
                      }
                      List followedAuthors = snapshot.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: authorslist.map((author) {
                          return Row(
                            children: [
                              Text(
                                author,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Follow_Card(
                                // follow author button
                                author: author,
                                followed: followedAuthors.contains(author),
                                ontoggle: () {
                                  setState(() {
                                    if (followedAuthors.contains(author)) {
                                      followedAuthors.remove(author);
                                    } else {
                                      followedAuthors.add(author);
                                    }
                                  });
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                  Text(
                    // actual Text
                    data['date'],
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: (data['words'] as List<dynamic>).map<Widget>((
                      word,
                    ) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          '       ${word.toString()}',
                          style: GoogleFonts.lora(fontSize: 19, height: 1.5),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    // recs
                    "Recommended Articles",
                    style: TextStyle(
                      fontSize: 25,
                      color: const Color.fromARGB(255, 12, 67, 111),
                    ),
                  ),
                  FutureBuilder(
                    future: recs,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: SpinKitCubeGrid(
                            color: const Color.fromARGB(255, 2, 4, 88),
                            size: 75,
                          ),
                        );
                      }
                      if (!snapshot.hasData || snapshot.hasError) {
                        return Center(
                          child: SpinKitCubeGrid(
                            color: const Color.fromARGB(255, 2, 4, 88),
                            size: 75,
                          ),
                        );
                      }
                      List<Article> recommendations = snapshot.data;
                      processedArticles = recommendations.map((article) {
                        return ArticleWithReadStatus(
                          article: article,
                          isRead: readarticles.contains(article.Article_ID),
                        );
                      }).toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: processedArticles.map((recommend) {
                          return Padding(
                            padding: const EdgeInsetsGeometry.fromLTRB(
                              0,
                              15,
                              0,
                              0,
                            ),
                            child: CurrentCardbuild(
                              article: recommend,
                              onleave: onLeave,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
