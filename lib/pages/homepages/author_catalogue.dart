import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/cardbuilder.dart';
import '../../services/cardclass.dart';
import 'package:The_Gilman_News/services/cache.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:The_Gilman_News/services/author.card.dart';
import '/services/stats/Articlestorage.dart';
import 'package:The_Gilman_News/pages/homepages/author_catalogue_search.dart';
import 'package:The_Gilman_News/services/globals.dart';

class AuthorCat extends StatefulWidget {
  // TODO: Reformat to make Author Catalogue
  final int tab_index;
  final RouteObserver<ModalRoute<void>> observer;
  const AuthorCat({super.key, required this.tab_index, required this.observer});
  @override
  State<AuthorCat> createState() => AuthorCatState();
}

class AuthorCatState extends State<AuthorCat> with RouteAware {
  CacheManager cacheManager = CacheManager();
  bool _isRouteVisible = false; // is on current tab?
  bool _isTabVisible = false; // is on current screen?
  bool show_to_top = false; // handles whether the scroll to top widget shows up
  Storedata storedata = Storedata();
  List<dynamic> followed_authors = [];

  final ScrollController _scrollController = ScrollController();
  List<String?> authorlist = [];
  late Future _future;
  late int version_num =
      cacheManager.get('author_catalogue_version_number') ?? 0;

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

  void refreshPage() {
    datarefresher();
  }

  @override
  initState() {
    super.initState();

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

  void datarefresher() async {
    followed_authors = await storedata.followed_author_reader();
    setState(() {}); //rebuilds followed widgets
  }

  Future<List> datagenerator() async {
    followed_authors = await storedata.followed_author_reader();

    cacheManager.save('author_catalogue_version_number', 0);
    version_num = 0;
    var online_version_number = await Supabase.instance.client
        .from('Version_Numbers')
        .select('Table_Name, Version')
        .eq('Table_Name,', 'Articles')
        .single();
    if (online_version_number['Version'] != version_num) {
      return getdata(online_version_number['Version']);
    }
    return Future.value(cacheManager.get('author_catalogue_cards'));
  } // TODO: fix bug where the data is rebuilt upon author profile page popping

  Future<List> getdata(int vnum) async {
    print('supabase call');
    var data = await Supabase.instance.client
        .from('Exploded_Author_List')
        .select('Author')
        .order('Author', ascending: true);
    cacheManager.save('author_catalogue_version_number', vnum);
    print(data);
    cacheManager.save('author_catalogue_cards', data);
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 158, 175, 206),
      body: NestedScrollView(
        controller: _scrollController,
        floatHeaderSlivers: false,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading: BackButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              forceElevated: true,
              shadowColor: Colors.black,
              elevation: 4.0,
              backgroundColor: const Color.fromARGB(255, 34, 72, 92),
              expandedHeight: 180,
              collapsedHeight: 80,
              pinned: false,
              flexibleSpace: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'lib/images/Author_Catalogue.png',
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
                            child: Text(
                              'Author Catalogue',
                              style: GoogleFonts.libreCaslonText(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
        }, // Start of actual body
        body: Scaffold(
          backgroundColor: const Color.fromARGB(255, 158, 175, 206),
          body: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final List instruments = snapshot.data! as List;
              authorlist = instruments.map((author) {
                return author?['Author'] as String;
              }).toList();
              return NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollUpdateNotification) {
                    double currentOffset = scrollNotification.metrics.pixels;
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
                child: ListView.builder(
                  itemCount: instruments.length + 1,
                  itemBuilder:
                      ((context, index) {
                        if (index == 0) {
                          return Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                overlayColor: Colors.blue,
                                backgroundColor: const Color.fromARGB(
                                  221,
                                  44,
                                  43,
                                  55,
                                ),
                              ),
                              onPressed: () {
                                showSearch(
                                  context: context,
                                  delegate: Author_Search(
                                    follow_changes:
                                        Globals.followedAuthorNotifier,
                                    authors: authorlist,
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 10,
                                  children: [
                                    Text(
                                      'Search',
                                      style: GoogleFonts.lora(
                                        fontSize: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Icon(
                                      Icons.search,
                                      size: 40,
                                      color: const Color.fromARGB(
                                        255,
                                        255,
                                        255,
                                        255,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        final author = authorlist[index - 1];
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                          child: Author_Card(
                            author: author ?? '',
                            followed: followed_authors.contains(author),
                            ontoggle: () {
                              setState(() {
                                if (followed_authors.contains(author)) {
                                  followed_authors.remove(author);
                                } else {
                                  followed_authors.add(author);
                                }
                              });
                            },
                          ),
                        );
                      } // itemBuilder function
                      ), //itembuilder parenthesis,
                ),
              );
            },
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
      ),
    );
  }
}
