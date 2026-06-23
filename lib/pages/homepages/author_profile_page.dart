import 'package:The_Gilman_News/services/following_system.dart';
import 'package:The_Gilman_News/services/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/cardbuilder.dart';
import '../../services/cardclass.dart';
import 'package:The_Gilman_News/services/cache.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:The_Gilman_News/services/author.card.dart';
import '/services/stats/Articlestorage.dart';
import 'package:supabase/supabase.dart';

class AuthorProfilePage extends StatefulWidget {
  final int tab_index;
  final RouteObserver<ModalRoute<void>> observer;
  const AuthorProfilePage({
    super.key,
    required this.tab_index,
    required this.observer,
  });

  @override
  State<AuthorProfilePage> createState() => AuthorProfilePageState();
}

class AuthorProfilePageState extends State<AuthorProfilePage> with RouteAware {
  CacheManager cacheManager = CacheManager();
  bool _isRouteVisible =
      false; // is on current tab? currently vestigial will revisit
  bool _isTabVisible = false; // is on current screen?
  bool show_to_top = false; // handles whether the scroll to top widget shows up
  Storedata storedata = Storedata();
  Object? args = {};
  final ScrollController _scrollController = ScrollController();
  String authorName = '';
  String startDate = '';
  String endDate = '';
  int numArticles = 0;
  int numCollabs = 0;
  Set readarticles = {};
  String? bio = null;
  String? _class =
      null; //use _ because class can't used as code thinks I am referring to a class object
  String? url = null;
  String? highestPosition = null;
  bool followed = false;
  late Future<List> sole_articles;
  late Future<List> collab_articles;
  bool initialized = false;

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
    print('called');
    final cached = await cacheManager.get("read_articles") ?? [];
    readarticles = cached.toSet();
    Globals.globalReadArticlesNotifier.value = Set<int>.from(cached);
    setState(() {});
  }

  @override
  initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map) {
        final Map data = args as Map;
        authorName = data['author'];
        numArticles = data['num_of_articles'];
        numCollabs = data['num_of_collabs'];
        startDate = data['first_article'];
        endDate = data['last_article'];
        bio = data['bio'];
        _class = data['Class'];
        url = data['Image_Url'];
        highestPosition = data["Position"];
        followed = data['Initial_State'];
      }
      ;
      sole_articles = solegenerator();
      collab_articles = collabgenerator();
      initialized = true;
    }
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      widget.observer.subscribe(this, route);
    }
  }

  Future<List<dynamic>> solegenerator() async {
    final cached = await cacheManager.get("read_articles") ?? [];
    readarticles = cached.toSet();
    final data = await Supabase.instance.client
        .from('AuthorTable')
        .select('*')
        .eq('Author', authorName);
    return data;
  }

  Future<List<dynamic>> collabgenerator() async {
    final data = await Supabase.instance.client
        .from('AuthorTable')
        .select('*')
        .like('Author', '%$authorName%')
        .neq('Author', authorName);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 134, 167, 224),
        child: Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      backgroundColor: const Color.fromARGB(255, 204, 218, 225),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              spacing: 15,
              children: [
                SizedBox(height: MediaQuery.sizeOf(context).height / 8),
                if (url != null)
                  Image.network(
                    url ?? '',
                    fit: BoxFit.cover,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                          if (frame == null) {
                            return Container(
                              height: 350,
                              child: const Center(
                                child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 10,
                                    color: Color.fromARGB(255, 9, 8, 50),
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
                                  color: const Color.fromARGB(255, 9, 8, 50),
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
                            color: Color.fromARGB(255, 0, 75, 141),
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                Text(
                  '$authorName ${_class ?? ''}',
                  style: GoogleFonts.lora(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Big_Follow_Card(
                  author: authorName,
                  followed: followed,
                  ontoggle: () {
                    setState(() {
                      if (followed) {
                        followed = false;
                        return;
                      }
                      if (!followed) {
                        followed = true;
                        return;
                      }
                    });
                  },
                ),
                if (highestPosition != null)
                  Text(
                    'Current Position : $highestPosition',
                    style: GoogleFonts.lora(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                Text(
                  'Number of Articles Written : ${numArticles.toString()}',
                  style: GoogleFonts.lora(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Number of Collaborations With Others : ${numCollabs.toString()}',
                  style: GoogleFonts.lora(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                Text(
                  (startDate == endDate)
                      ? 'Edition Contributed To : ${startDate}'
                      : 'First Edition Contributed To : ${startDate}',
                  style: GoogleFonts.lora(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                if (startDate != endDate)
                  Text(
                    'Last Edition Contributed To : ${endDate}',
                    style: GoogleFonts.lora(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                if (bio != null && bio != '')
                  Text(
                    'Bio : $bio',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lora(fontSize: 18),
                  ),
                if (numArticles != numCollabs)
                  FutureBuilder(
                    // this check ensures that an author who only collabed doesn't have an empty expandable list
                    future: sole_articles,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data =
                            snapshot.data ??
                            []; // allows us to bypass nullable constraint because we know it can be null from if statement
                        List<Article> articlelist = data.map((e) {
                          return Article(
                            author: e['Author'],
                            Article_ID: e['article_id'],
                            Date: e['date'],
                            Article_Title: e['Article_Title'],
                            edition_num: e['edition_num'],
                            tags: List<String>.from(e['Categories']),
                          );
                        }).toList();
                        List<ArticleWithReadStatus> processed_articles =
                            articlelist.map((e) {
                              return ArticleWithReadStatus(
                                article: e,
                                isRead: readarticles.contains(e.Article_ID),
                              );
                            }).toList();
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ExpansionTile(
                            expansionAnimationStyle: AnimationStyle(
                              duration: Duration(seconds: 1),
                            ),
                            title: const Text(
                              'View Articles Written Only By this Author',
                            ),
                            trailing: const Icon(Icons.keyboard_arrow_down),
                            children: [
                              Material(
                                color: const Color.fromARGB(255, 204, 218, 225),
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: processed_articles.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Other_Instances_Cardbuild(
                                        article: processed_articles[index],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return SpinKitCircle(color: Colors.black, size: 40);
                    },
                  ),
                FutureBuilder(
                  future: collab_articles,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data =
                          snapshot.data ??
                          []; // allows us to bypass nullable constraint because we know it can be null from if statement
                      List<Article> articlelist = data.map((e) {
                        return Article(
                          author: e['Author'],
                          Article_ID: e['article_id'],
                          Date: e['date'],
                          Article_Title: e['Article_Title'],
                          edition_num: e['edition_num'],
                          tags: List<String>.from(e['Categories']),
                        );
                      }).toList();
                      List<ArticleWithReadStatus> processed_articles =
                          articlelist.map((e) {
                            return ArticleWithReadStatus(
                              article: e,
                              isRead: readarticles.contains(e.Article_ID),
                            );
                          }).toList();
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ExpansionTile(
                          expansionAnimationStyle: AnimationStyle(
                            duration: Duration(seconds: 1),
                          ),
                          title: const Text(
                            'View Articles Written By this Author in Collaboration with Others',
                          ),
                          trailing: const Icon(Icons.keyboard_arrow_down),
                          children: [
                            Material(
                              color: const Color.fromARGB(255, 204, 218, 225),
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: processed_articles.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Other_Instances_Cardbuild(
                                      article: processed_articles[index],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return SpinKitCircle(color: Colors.black, size: 40);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
