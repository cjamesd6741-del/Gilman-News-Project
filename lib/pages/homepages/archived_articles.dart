import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/cardbuilder.dart';
import '../../services/cardclass.dart';
import 'package:The_Gilman_News/services/cache.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class ArchivedArticles extends StatefulWidget {
  final int tab_index;
  final RouteObserver<ModalRoute<void>> observer;
  const ArchivedArticles({
    super.key,
    required this.tab_index,
    required this.observer,
  });
  @override
  State<ArchivedArticles> createState() => ArchivedArticlesState();
}

class ArchivedArticlesState extends State<ArchivedArticles> with RouteAware {
  CacheManager cacheManager = CacheManager();
  bool _isRouteVisible = false; // is on current tab?
  bool _isTabVisible = false; // is on current screen?
  late List<ArticleWithReadStatus> processedArticles;
  late Set readarticles;
  List<Article> articlelist = [];
  ScrollController _scrollController = ScrollController();
  bool show_to_top = false;
  late Future _future;
  late int version_num =
      cacheManager.get('current_article_version_number') ??
      0; // kept same as current artiicles because in theory this being update would cascade to archived articles

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
    refreshPage();
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

  void onTabVisible() {
    debugPrint("hello");
    refreshPage();
  }

  void refreshPage() async {
    final cached = await cacheManager.get("read_articles") ?? [];
    readarticles = Set<int>.from(cached);
    setState(() {
      _future = datagenerator();
    });
  }

  @override
  initState() {
    super.initState();
    final cached = cacheManager.get("read_articles") ?? [];
    readarticles = cached.toSet();
    _future = datagenerator();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      widget.observer.subscribe(this, route);
    }
  }

  Future<List> datagenerator() async {
    var online_version_number = await Supabase.instance.client
        .from('Version_Numbers')
        .select('Table_Name, Version')
        .eq('Table_Name,', 'Current_Articles')
        .single();
    if (online_version_number['Version'] != version_num) {
      return getdata(online_version_number['Version']);
    }
    return Future.value(cacheManager.get('archived_article_cards'));
  }

  Future<List> getdata(int vnum) async {
    var data = await Supabase.instance.client
        .from('Archived_Articles')
        .select(
          'Author, Article_Title, Date, Article_ID, edition_num, Categories',
        )
        .order('edition_num', ascending: true);
    cacheManager.save('current_article_version_number', vnum);
    cacheManager.save('archived_article_cards', data);
    return data;
  }

  void scroll_to_top() {
    _scrollController.animateTo(
      0,
      duration: Duration(seconds: 1, milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double expandedHeight = max(screenHeight / 8, 100.0);
    final double collapsedHeight = max(screenHeight / 12, 70.0);
    final width = MediaQuery.sizeOf(context).width - 72;

    return NestedScrollView(
      controller: _scrollController,
      floatHeaderSlivers: false,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back, color: Colors.white),
            ),

            forceElevated: true,
            shadowColor: Colors.black,
            elevation: 4.0,
            backgroundColor: const Color.fromARGB(255, 34, 72, 92),
            expandedHeight: expandedHeight,
            collapsedHeight: collapsedHeight,
            toolbarHeight: collapsedHeight,
            pinned: true,
            flexibleSpace: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'lib/images/Archived_Articles.png',
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
                        padding: const EdgeInsets.only(bottom: 6),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Gilman News',
                                style: GoogleFonts.libreCaslonText(
                                  fontSize: 20 + width / 50,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Archived Articles',
                                style: GoogleFonts.libreCaslonText(
                                  fontSize: 20 + width / 50,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white,
                                ),
                              ),
                            ],
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
      body: Scaffold(
        backgroundColor: const Color.fromARGB(255, 158, 175, 206),
        floatingActionButton: AnimatedOpacity(
          opacity: show_to_top ? 1 : 0,
          duration: Duration(milliseconds: 500),
          child: FloatingActionButton(
            onPressed: scroll_to_top,
            backgroundColor: const Color.fromARGB(255, 16, 75, 124),
            foregroundColor: Colors.white,
            child: Icon(Icons.arrow_upward, size: 30),
          ),
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: (scrollnotification) {
            if (scrollnotification is ScrollUpdateNotification) {
              double currentOffset = scrollnotification.metrics.pixels;
              if (currentOffset > 200 && !show_to_top) {
                setState(() {
                  show_to_top = true;
                });
              } else if (currentOffset < 200 && show_to_top) {
                setState(() {
                  show_to_top = false;
                });
              }
            }
            return true;
          },
          child: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final List instruments = snapshot.data! as List;
              articlelist = instruments.map((article) {
                List<String> tag = [];
                try {
                  tag = article["Categories"].cast<String>();
                } catch (_) {}

                return Article(
                  Article_ID: article['Article_ID'],
                  Article_Title: article['Article_Title'],
                  author: article['Author'],
                  Date: article['Date'],
                  edition_num: article["edition_num"] ?? 0.0,
                  tags: tag,
                );
              }).toList();
              processedArticles = articlelist.map((article) {
                return ArticleWithReadStatus(
                  article: article,
                  isRead: readarticles.contains(article.Article_ID),
                );
              }).toList();
              return ListView.builder(
                itemCount: instruments.length,
                itemBuilder:
                    ((context, index) {
                      final instrument = processedArticles[index];
                      return Padding(
                        padding: EdgeInsetsGeometry.symmetric(
                          horizontal: 5,
                          vertical: 10,
                        ),
                        child: Other_Instances_Cardbuild(
                          height: min(width * .8, 350),
                          width: (width - 10),
                          article: instrument,
                        ),
                      );
                    } // itemBuilder function
                    ), //itembuilder parenthesis,
              );
            },
          ),
        ),
      ),
    );
  }
}
