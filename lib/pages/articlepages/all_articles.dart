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
  ScrollController _scrollController = ScrollController();
  bool show_to_top = false;
  late List<ArticleWithReadStatus> processedArticles;
  late Set readarticles;
  List<Article> articlelist = [];
  late int version_num = cacheManager.get('article_version_number') ?? 0;
  late Future _future;
  bool _isRouteVisible = false; // is on current tab?
  bool _isTabVisible = false; // is on current screen?
  ValueNotifier<Set<int>> readArticlesNotifier = ValueNotifier({});
  Random rand = Random();

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
        .eq('Table_Name', 'Articles')
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
        .select(
          'Author, Article_Title, Date, Article_ID, edition_num, Categories',
        );
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
      _future = datagenerator(); // why is this called every time, fix
    });
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
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              // top bar
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
                      'lib/images/IMG_0425.png',
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
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 200),
                                  style: GoogleFonts.libreCaslonText(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: innerBoxIsScrolled
                                        ? Color.fromARGB(255, 255, 255, 255)
                                        : Color.fromARGB(255, 19, 28, 83),
                                  ),
                                  child: Text('Gilman News'),
                                ),
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 200),
                                  style: GoogleFonts.libreCaslonText(
                                    fontSize: 24,
                                    fontStyle: FontStyle.italic,
                                    color: innerBoxIsScrolled
                                        ? Color.fromARGB(255, 255, 255, 255)
                                        : Color.fromARGB(255, 19, 28, 83),
                                  ),
                                  child: Text('All Articles'),
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
              final List instruments = snapshot.data as List;

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

              processedArticles.sort(
                (b, a) =>
                    a.article.edition_num.compareTo(b.article.edition_num),
              ); //organized by date

              return CustomScrollView(
                key: const PageStorageKey<String>('all_articles_scroll'),
                slivers: [
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                      context,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 10),
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            showSearch(
                              context: context,
                              delegate: AllArticleSearch(
                                articles: processedArticles,
                                readnotifier:
                                    Globals.globalReadArticlesNotifier,
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.search_rounded,
                            color: Colors.black,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Random Article Button
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      child: Center(
                        child: InkWell(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 17, 49, 103),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 73, 81, 95),
                                  blurRadius: 6,
                                  offset: Offset.fromDirection(2, 5),
                                ),
                              ],
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(width: 10),
                                  Text(
                                    "Random Article",
                                    style: GoogleFonts.lora(
                                      color: Colors.white,
                                      fontSize: 30,
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                  const FaIcon(
                                    FontAwesomeIcons.diceSix,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            ),
                          ),
                          onTap: () async {
                            if (Globals.clicked == false) {
                              Globals.clicked = true;
                              await Future.delayed(
                                const Duration(milliseconds: 350),
                              );
                              int random_item_index = rand.nextInt(
                                processedArticles.length,
                              );
                              Article randomarticle =
                                  articlelist[random_item_index];
                              Navigator.pushNamed(
                                context,
                                '/loading',
                                arguments: {
                                  'title': randomarticle.Article_Title,
                                  'author': randomarticle.author,
                                  'ID': randomarticle.Article_ID,
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),

                  // List
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final instrument = processedArticles[index];
                      return Padding(
                        padding: EdgeInsetsGeometry.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: Other_Instances_Cardbuild(article: instrument),
                      );
                    }, childCount: processedArticles.length),
                  ),
                ],
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
