import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/cardbuilder.dart';
import '../services/cardclass.dart';
import 'package:apitest_2/services/cache.dart';

class CurrentArticles extends StatefulWidget {
  final int tab_index;
  final RouteObserver<ModalRoute<void>> observer;
  const CurrentArticles({
    super.key,
    required this.tab_index,
    required this.observer,
  });
  @override
  State<CurrentArticles> createState() => CurrentArticlesState();
}

class CurrentArticlesState extends State<CurrentArticles> with RouteAware {
  CacheManager cacheManager = CacheManager();
  bool _isRouteVisible = false; // is on current tab?
  bool _isTabVisible = false; // is on current screen?
  late List<ArticleWithReadStatus> processedArticles;
  late Set readarticles;
  List<Article> articlelist = [];
  late Future _future;
  late int version_num =
      cacheManager.get('current_article_version_number') ?? 0;

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
      _future = datagenerator(); // 🔥 refetch data
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
    return Future.value(cacheManager.get('current_article_cards'));
  }

  Future<List> getdata(int vnum) async {
    var data = await Supabase.instance.client
        .from('Current_Articles')
        .select('Author, Article_Title, Date, Article_ID');
    cacheManager.save('current_article_version_number', vnum);
    cacheManager.save('current_article_cards', data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 158, 175, 206),
      body: NestedScrollView(
        floatHeaderSlivers: false,
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
                  Image.asset(
                    'lib/images/gilmanschool2.png',
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
                                'Gilman News',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Current Articles',
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
        body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final List instruments = snapshot.data! as List;
            articlelist = instruments.map((article) {
              return Article(
                Article_ID: article['Article_ID'],
                Article_Title: article['Article_Title'],
                author: article['Author'],
                Date: article['Date'],
                edition_num: article["edition_num"] ?? 0.0,
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
                    return ListTile(title: Cardbuild(article: instrument));
                  } // itemBuilder function
                  ), //itembuilder parenthesis,
            );
          },
        ),
      ),
    );
  }
}
