import 'dart:collection';
import 'dart:math';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:The_Gilman_News/services/following_system.dart';
import '/services/similarity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '/services/stats/Articlestorage.dart';
import '/services/appbartext.dart';
import '/services/back_from_rec.dart';
import 'package:The_Gilman_News/services/cache.dart';
import '../../services/cardclass.dart';
import 'package:The_Gilman_News/services/cardbuilder.dart';
import 'package:The_Gilman_News/services/carousel_image.dart';
import 'package:intl/intl.dart';

class Article_of_the_Day_Page extends StatefulWidget {
  // Substantiate necessary vars
  // shows the actual article
  final int
  tab_index; // tells what tab this instance of article page is on (either 1 or 2 for now)
  final RouteObserver<ModalRoute<void>>
  observer; // routeobserver so allows didPop didPush etc. not very necessary in the current config
  const Article_of_the_Day_Page({
    super.key,
    required this.tab_index,
    required this.observer,
  });

  @override
  State<Article_of_the_Day_Page> createState() =>
      Article_of_the_Day_PageState();
}

class Article_of_the_Day_PageState extends State<Article_of_the_Day_Page>
    with RouteAware {
  CacheManager cacheManager = CacheManager(); // create cache instance
  bool _isRouteVisible = false; // is on current tab?
  bool _isTabVisible = false; // is on current screen?
  Storedata storedata = Storedata(); // class for data storage
  Textconfigure textconfigure = Textconfigure(); // for sizing of title text
  TextStyle appbartextStyle = GoogleFonts.ebGaramond(
    fontSize: 18,
    height: 1.2,
    color: Color.fromARGB(255, 25, 38, 56),
    fontWeight: FontWeight.bold,
  ); // tells textconfigure the size to calc
  List categories = []; // categories
  Stopwatch stopwatch = Stopwatch(); // tracks amount of time in article
  List authorslist = [];
  String authors = '';
  Similarity_Finder similar = Similarity_Finder(); // creates recommendations
  int id = 0; // no clue
  int current_image_index = 0; // controls carousel
  late Future<List<Article>> recs;
  bool _initialized = false; // prevents double initialization later
  String prevauthor = ''; // init
  String prevtitle = ''; // init
  DateTime now = DateTime.now();
  int previd = 0;
  bool recommended =
      false; //note this variable is only used to determine if the current article was pushed by an recommend button, in which case we create a way for the reader to go back
  Map data = {};
  late Future followed_authors;
  late List<ArticleWithReadStatus> processedArticles;
  late Set readarticles;
  Set number_of_fingers = {};
  final TransformationController _transformationController =
      TransformationController();
  bool _isZoomed = false;
  late dynamic args;
  late double width;
  late double height;

  @override
  initState() {
    super.initState();
    final cached = cacheManager.get("read_articles") ?? []; //gets read articles
    readarticles = cached.toSet(); // use set for quick searching through
    followed_authors = storedata
        .followed_author_reader(); // gets followed authors
    storedata.updatearticleread(); // +1 to articles read
    stopwatch.start();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // runs 1 frame after the creation of element

      args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map) {
        categories = args['category'] ?? [];
        storedata.categorywriter(categories); // updates categories
        storedata.past10update(ListQueue.from(categories)); // updates recents
        if (args['recommended'] == true) {
          setState(() {
            recommended = true;
            prevauthor = args['prevauthor'] ?? "";
            prevtitle = args['prevtitle'] ?? "";
            previd = args['prevID'] ?? 0;
          });
        }
      } else {
        print("no args sent to article of the day page");
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
      args = ModalRoute.of(context)?.settings.arguments;
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
    width = MediaQuery.sizeOf(context).width - 72;
    if (recommended == true) {
      width = MediaQuery.sizeOf(context).width - 102;
    }
    height = textconfigure.textHeight(
      width,
      data['title'] ?? 'Article',
      appbartextStyle,
    );
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
    if (args == null) {
      return SpinKitCircle(
        color: const Color.fromARGB(255, 23, 69, 107),
        size: 50.0,
      );
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          onLeave();
        }
      },
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: MediaQuery.of(
                  context,
                ).textScaler.clamp(maxScaleFactor: 1.2),
              ),
              child: SliverAppBar(
                elevation: 10,
                forceElevated: true,
                snap: true,
                floating: true,
                shadowColor: const Color.fromARGB(255, 0, 0, 0),
                backgroundColor: Color.fromARGB(255, 234, 225, 211),
                toolbarHeight: (recommended) ? height + 100 : height + 50,
                title: Text(
                  'Article of The Day - ${DateFormat.yMMMMEEEEd().format(now)}',
                  softWrap: true,
                  maxLines: null,
                  overflow: TextOverflow.visible,
                  style: appbartextStyle,
                ),
              ),
            ),
          ];
        },
        body: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(
              context,
            ).textScaler.clamp(maxScaleFactor: 3),
          ),
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 236, 213, 201),
            // actual layout
            body: SingleChildScrollView(
              physics: _isZoomed
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 245, 235, 230),
                  image: DecorationImage(
                    opacity: .3,
                    image: AssetImage('lib/images/old_paper.jpg'),
                    repeat: ImageRepeat.repeat,
                    fit: BoxFit.none,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 16.0, 10.0, 0),
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
                              options: CarouselOptions(
                                scrollPhysics: _isZoomed
                                    ? const NeverScrollableScrollPhysics()
                                    : const BouncingScrollPhysics(),
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    current_image_index = index;
                                  });
                                },
                                viewportFraction: .80,
                                height: 400,
                                enlargeCenterPage: true,
                                enableInfiniteScroll: true,
                                autoPlay: false,
                              ),
                              items: List.generate(
                                (data['image_urls'] as List).length,
                                (index) {
                                  final url = data['image_urls'][index];
                                  final labels = data['image_labels'] as List?;
                                  return CarouselImage(
                                    zoom_update: (bool _zoomed) {
                                      setState(() {
                                        _isZoomed = _zoomed;
                                      });
                                    },
                                    url: url,
                                    label: labels?[index],
                                  );
                                },
                              ),
                            ),
                          ),
                        ), // if there are multiple images, show a carousel
                      if (data['image_urls'] != null &&
                          (data['image_urls'] as List).length == 1) // one image
                        SelectionArea(
                          child: InteractiveViewer(
                            minScale: 1,
                            maxScale: 4,
                            transformationController: _transformationController,
                            onInteractionUpdate: (details) {
                              final double scale = _transformationController
                                  .value
                                  .getMaxScaleOnAxis();

                              if (scale > 1.0 && !_isZoomed) {
                                setState(() {
                                  _isZoomed = true;
                                });
                              } else if (scale <= 1.0 && _isZoomed) {
                                setState(() {
                                  _isZoomed = false;
                                });
                              }
                            },
                            child: Center(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
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
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
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
                                        if (loadingProgress == null)
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: child,
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
                                  if (data['image_labels'] != null &&
                                      (data['image_labels'] as List).isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16.0,
                                      ),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        data['image_labels'][0],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                ], //
                              ),
                            ),
                          ),
                        ),
                      InteractiveViewer(
                        minScale: 1,
                        maxScale: 3,
                        child: Column(
                          spacing: 16,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                data['title'],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (data['image_urls'] != null &&
                                (data['image_urls'] as List).length > 1)
                              Row(
                                spacing: 15,
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  for (
                                    int i = 0;
                                    i < (data['image_urls'] as List).length;
                                    i++
                                  )
                                    AnimatedScale(
                                      scale: (current_image_index == i) ? 2 : 1,
                                      duration: Duration(milliseconds: 300),
                                      child: Icon(
                                        Icons.circle,
                                        key: Key(i.toString()),
                                        size: 20,
                                        color: (current_image_index == i)
                                            ? Colors.black
                                            : const Color.fromARGB(
                                                255,
                                                222,
                                                234,
                                                144,
                                              ),
                                      ),
                                    ),
                                ],
                              ),
                            Text(
                              authors,
                              style: GoogleFonts.ebGaramond(fontSize: 20),
                            ),
                            Text(
                              // actual Text
                              data['date'],
                              style: GoogleFonts.ebGaramond(
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: SelectionArea(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: (data['words'] as List<dynamic>)
                                      .map<Widget>((word) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 12.0,
                                          ),
                                          child: Text(
                                            '       ${word.toString()}',
                                            style: GoogleFonts.ebGaramond(
                                              fontSize: 22,
                                              height: 1.5,
                                              color: Color.fromARGB(
                                                255,
                                                41,
                                                41,
                                                61,
                                              ),
                                            ),
                                          ),
                                        );
                                      })
                                      .toList(),
                                ),
                              ),
                            ),
                            Wrap(
                              spacing: 20,
                              runSpacing: 10,
                              children: [
                                TextButton(
                                  child: Text(
                                    "What is 'Article of The Day'?",
                                    style: GoogleFonts.lora(
                                      color: Colors.black,
                                    ),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        actions: [
                                          IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: 20,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                text: "The ",
                                                style:
                                                    GoogleFonts.playfairDisplay(
                                                      fontSize: 16 + width / 60,
                                                      color: Colors.black,
                                                    ),
                                                children: [
                                                  TextSpan(
                                                    text: "Article of The Day",
                                                    style: GoogleFonts.playfairDisplay(
                                                      fontSize: 18 + width / 60,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            35,
                                                            119,
                                                            187,
                                                          ),
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        " column displays, as described by its name, one unique article each day. All articles that may appear here have been handpicked from the archives as to be as interesting and informative to read as possible. They mainly cover events relevant to the school's history, but this often overlaps with what was happening in the broader world at the time.",
                                                    style: GoogleFonts.playfairDisplay(
                                                      fontSize: 16 + width / 60,
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            0,
                                                            0,
                                                            0,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              "Idea Courtesy of Aarav Trivedi '28",
                                              style:
                                                  GoogleFonts.playfairDisplay(
                                                    fontSize: 12 + width / 80,
                                                    fontStyle: FontStyle.italic,
                                                    color: const Color.fromARGB(
                                                      255,
                                                      0,
                                                      0,
                                                      0,
                                                    ),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      161,
                                      193,
                                      219,
                                    ),
                                    side: BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pushNamed('/archived_articles');
                                  },
                                  child: Text(
                                    "See Other Archived Articles",
                                    style: GoogleFonts.lora(
                                      color: Colors.black,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      128,
                                      109,
                                      83,
                                    ),
                                    side: BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
