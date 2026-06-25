import 'package:The_Gilman_News/services/cache.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/cardbuilder.dart';
import '../../services/cardclass.dart';
import 'articlesearch.dart';
import 'package:The_Gilman_News/services/globals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:The_Gilman_News/services/globals.dart';

class EditionViewer extends StatefulWidget {
  final int
  tabindex; // might be unecessary given this only occurs on a set tab, fix this in the future to optimize
  final RouteObserver<ModalRoute<void>> observer;
  const EditionViewer({
    super.key,
    required this.observer,
    required this.tabindex,
  });

  @override
  State<EditionViewer> createState() => _EditionViewerState();
}

class _EditionViewerState extends State<EditionViewer> with RouteAware {
  List<Article> articles = [];
  CacheManager cacheManager = CacheManager();
  ScrollController _scrollController = ScrollController();
  bool show_to_top = false;
  late List<ArticleWithReadStatus> processedArticles;
  late Set readarticles;
  List<Article> articlelist = [];
  late int version_num = cacheManager.get('editions_version_number') ?? 0;
  late Future _future;
  bool _isRouteVisible = false; // is on current tab?
  bool _isTabVisible = true; // is on current screen?
  ValueNotifier<Set<int>> readArticlesNotifier = ValueNotifier({});

  @override // remove the observer because we are deleting the page
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
    _isRouteVisible =
        true; // might want to bring this back into checks for performance later because entire stack is rebuilding right now
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
    if (_isTabVisible == visible)
      return; // only act if state changes also unecessary currently
    _isTabVisible = visible;

    if (visible) {
      _checkIfShouldRefresh();
    }
  }

  void _checkIfShouldRefresh() {
    if (_isTabVisible) {
      // unecessary check because this is garunteed TODO: Fix refresh system for all pages to only fire if on top of stack
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

  Future<List<Map<String, dynamic>>> datagenerator() async {
    var online_version_number = await Supabase.instance.client
        .from('Version_Numbers')
        .select('Table_Name, Version')
        .eq('Table_Name', 'Articles')
        .single();
    print(online_version_number['Version']);
    if (online_version_number['Version'] != version_num) {
      print('true');
      return getdata(online_version_number['Version']);
    }
    var rawCachedData = await cacheManager.get('editions_info');
    print('Raw Cache Data: $rawCachedData');

    return (rawCachedData as List)
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getdata(int vnum) async {
    version_num = vnum;
    print('supabase call');
    var data = await Supabase.instance.client
        .from('editions')
        .select('*')
        .order('edition_num', ascending: true);
    cacheManager.save('editions_version_number', version_num);
    print(data);
    cacheManager.save('editions_info', data);
    return data.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  @override
  initState() {
    super.initState();
    final cached = cacheManager.get("read_articles") ?? [];
    readArticlesNotifier = ValueNotifier(Set<int>.from(cached));
    readarticles = cached.toSet();
    _future = datagenerator();
  }

  void refreshPage() async {
    final cached = await cacheManager.get("read_articles") ?? [];
    Globals.globalReadArticlesNotifier.value = Set<int>.from(cached);
    setState(() {
      readarticles = cached.toSet();
    });
  }

  void onTabVisible() {
    refreshPage();
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
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            leading: BackButton(
              //adds backbutton. you wont see this in all pages because flutter already does this by default, the only reason it is here is because the button should be white to stand out
              color: innerBoxIsScrolled
                  ? Color.fromARGB(255, 255, 255, 255)
                  : const Color.fromARGB(255, 0, 0, 0),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            forceElevated: true,
            shadowColor: Colors.black,
            elevation: 4.0,
            backgroundColor: const Color.fromARGB(255, 30, 85, 131),
            expandedHeight: MediaQuery.sizeOf(context).height / 8,
            collapsedHeight: max(80, MediaQuery.sizeOf(context).height / 12),
            pinned: true,
            floating: false,
            flexibleSpace: Stack(
              fit: StackFit.expand,
              children: [
                FlexibleSpaceBar(
                  background: Image.asset(
                    'lib/images/Editions.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  // stacked widgets that become transparent to let widgets below them show when inner box is not scrolled
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    height: double.infinity,
                    color: innerBoxIsScrolled
                        ? const Color.fromARGB(255, 30, 85, 131)
                        : Colors.transparent,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: GoogleFonts.libreCaslonText(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: innerBoxIsScrolled
                                  ? Color.fromARGB(255, 255, 255, 255)
                                  : const Color.fromARGB(255, 0, 0, 0),
                            ),
                            child: Text('Edition Viewer'),
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

              final List<Map<String, dynamic>> listEditions = snapshot.data;
              return ListView.builder(
                itemCount: listEditions.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> edition = listEditions[index];
                  return Edition_Single(
                    edition: edition,
                    readArticlesNotifier: Globals.globalReadArticlesNotifier,
                  );
                },
              );
            },
          ),
        ),
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
      ),
    );
  }
}

class Edition_Single extends StatefulWidget {
  final Map<String, dynamic> edition;
  final ValueNotifier readArticlesNotifier;
  const Edition_Single({
    super.key,
    required this.edition,
    required this.readArticlesNotifier,
  });

  @override
  State<Edition_Single> createState() => _Edition_SingleState();
}

class _Edition_SingleState extends State<Edition_Single> {
  Future<List<Map<String, dynamic>>>? _articlesFuture;
  double edition_num = 0;
  String date = '';

  @override
  void initState() {
    super.initState();
    edition_num = widget.edition['edition_num'];
    date = widget.edition['Date'];
  }

  void loading() {
    if (_articlesFuture == null) {
      // if empty, allows basic cashing, in the future want to add more long term cashing
      setState(() {
        double edition_num = widget.edition['edition_num'];
        _articlesFuture = Supabase.instance.client
            .from('edition_viewer')
            .select('*')
            .eq('edition_num', edition_num);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.edition['Date']),
      children: [
        if (_articlesFuture == null)
          const SizedBox.shrink()
        else
          FutureBuilder(
            future: _articlesFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return SpinKitCircle(color: Colors.black, size: 50);
              }
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              print(snapshot.data);
              final List rawdata = snapshot.data;
              final articlelist = rawdata.map((article) {
                List<String> tag = [];
                try {
                  tag = article["Categories"].cast<String>();
                } catch (_) {}
                return Article(
                  Article_ID: article['article_id'],
                  Article_Title: article['Article_Title'],
                  author: article['Author'],
                  Date: date,
                  edition_num: edition_num,
                  tags: tag,
                );
              }).toList();

              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: articlelist.length,
                itemBuilder: (BuildContext context, int index) {
                  final article = articlelist[index];
                  return ValueListenableBuilder(
                    valueListenable: widget.readArticlesNotifier,
                    builder: (context, read_articles, child) {
                      ArticleWithReadStatus processedArticle =
                          ArticleWithReadStatus(
                            article: article,
                            isRead: read_articles.contains(article.Article_ID),
                          );

                      return Padding(
                        padding: EdgeInsets.all(8),
                        child: Other_Instances_Cardbuild(
                          article: processedArticle,
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
      ],
      onExpansionChanged: (value) {
        loading();
      },
    );
  }
}
