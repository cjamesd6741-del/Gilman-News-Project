import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:apitest_2/pages/article_page.dart';
import 'package:apitest_2/pages/loading.dart';
import 'package:apitest_2/pages/all_articles.dart';
import 'package:apitest_2/pages/currentarticles.dart';
import 'package:apitest_2/pages/stats.dart';
import 'package:apitest_2/pages/article_page.dart';
import 'package:apitest_2/pages/loading.dart';
import 'package:apitest_2/pages/home_page.dart';

class Route_Manager extends StatefulWidget {
  const Route_Manager({super.key});

  @override
  State<Route_Manager> createState() => _Route_ManagerState();
}

class _Route_ManagerState extends State<Route_Manager> {
  int page_index = 0;
  List<Widget> pages = const [
    AllArticlesPage(),
    CurrentArticles(),
    Stats(),
    Text("Games")
  ];

  final _navigatorKeys = [
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  ];
  final GlobalKey<StatsState> _statsKey =
    GlobalKey<StatsState>();

  Widget _buildTabNavigator({
    required GlobalKey<NavigatorState> navigatorKey,
    required RouteFactory onGenerateRoute,
  }) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: onGenerateRoute,
    );
  }

  Route current_articlesRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Home_Page());

      case '/current_articles':
        return MaterialPageRoute(builder: (_) => CurrentArticles());

      case '/loading':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Loading(
          ),
        );

      case '/article_page':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Article_Page(
          ),
        );

    default:
      throw Exception('Invalid route: ${settings.name}');
  }
  }

    Route all_articlesRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => AllArticlesPage());

      case '/loading':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Loading(
          ),
        );

      case '/article_page':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Article_Page(
          ),
        );

    default:
      throw Exception('Invalid route: ${settings.name}');
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
      index: page_index,
      children: [
        _buildTabNavigator(
          navigatorKey: _navigatorKeys[0],
          onGenerateRoute: all_articlesRoutes,
        ),
        _buildTabNavigator(
          navigatorKey: _navigatorKeys[1],
          onGenerateRoute: current_articlesRoutes,
        ),
        _buildTabNavigator(
          navigatorKey: _navigatorKeys[2],
          onGenerateRoute: (settings) =>
          MaterialPageRoute(builder: (_) => Stats(key: _statsKey)),
        ),
        _buildTabNavigator(
          navigatorKey: _navigatorKeys[3],
          onGenerateRoute: (settings) =>
          MaterialPageRoute(builder: (_) => const Text("Games")),
        ),
      ],
    ),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 10, 62, 105),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: GNav(
            gap: 6,
            backgroundColor: const Color.fromARGB(255, 10, 62, 105),
            color: const Color.fromARGB(255, 135, 135, 135),
            tabBackgroundColor: const Color.fromARGB(255, 14, 90, 152),
            textStyle: TextStyle(fontSize: 19 , color: Colors.white),
            iconSize: 25,
            onTabChange: (index) {
              setState(() {
                page_index = index;// first one is the var stored while second one is the arg given
                if (index == 2) {
                  _statsKey.currentState?.onTabVisible();}
              });
            },
            tabs: const [
              GButton(
                icon: Icons.newspaper,
                text: "Articles", 
                ),
              GButton(
                icon: Icons.home,
                text: "Home", 
              ),
              GButton(
                icon: Icons.settings,
                text: "Personal", 
              ),
              GButton(
                icon: Icons.gamepad_sharp,
                text: "Games",
                )
            ]),
        ),
      ),
    );
  }
}

