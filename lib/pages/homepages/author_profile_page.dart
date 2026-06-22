import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/cardbuilder.dart';
import '../../services/cardclass.dart';
import 'package:The_Gilman_News/services/cache.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:The_Gilman_News/services/author.card.dart';
import '/services/stats/Articlestorage.dart';

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
  List<dynamic> followed_authors = [];
  Object? args = {};
  final ScrollController _scrollController = ScrollController();
  String authorName = '';
  String startDate = '';
  String endDate = '';
  int numArticles = 0;
  int numCollabs = 0;

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
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map) {
        final Map data = args as Map;
        print(data);
        setState(() {
          authorName = data['author'];
          numArticles = data['num_of_articles'];
          numCollabs = data['num_of_collabs'];
          startDate = data['first_article'];
          endDate = data['last_article'];
        });
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      backgroundColor: const Color.fromARGB(255, 190, 212, 223),
      body: Center(
        child: Column(
          spacing: 15,
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height / 8),
            Text(
              authorName,
              style: GoogleFonts.lora(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Number of Articles Written : ${numArticles.toString()}',
              style: GoogleFonts.lora(fontSize: 18),
            ),
            Text(
              'Number of Collaborations With Others : ${numCollabs.toString()}',
              style: GoogleFonts.lora(fontSize: 16),
            ),
            Text(
              (startDate == endDate)
                  ? 'Edition Contributed To : ${startDate}'
                  : 'First Edition Contributed To : ${startDate}',
              style: GoogleFonts.lora(fontSize: 15),
            ),
            if (startDate != endDate)
              Text(
                'First Edition Contributed To : ${endDate}',
                style: GoogleFonts.lora(fontSize: 15),
              ),
          ],
        ),
      ),
    );
  }
}
