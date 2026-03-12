import 'package:apitest_2/pages/about.dart';
import 'package:apitest_2/pages/masthead_page.dart';
import 'package:apitest_2/pages/misc_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:apitest_2/pages/article_page.dart';
import 'package:apitest_2/pages/loading.dart';
import 'package:apitest_2/pages/all_articles.dart';
import 'package:apitest_2/pages/currentarticles.dart';
import 'package:apitest_2/pages/stats.dart';
import 'package:apitest_2/pages/home_page.dart';
import 'package:apitest_2/pages/followed.dart';

class Route_Manager extends StatefulWidget {
  const Route_Manager({super.key});

  @override
  State<Route_Manager> createState() => _Route_ManagerState();
}

class _Route_ManagerState extends State<Route_Manager> {
  int page_index = 1;
  List<Widget> pages = const [
    AllArticlesPage(),
    CurrentArticles(),
    Text("Games"),
  ];

  final _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  final _routeObservers = [
    RouteObserver<ModalRoute<void>>(),
    RouteObserver<ModalRoute<void>>(),
    RouteObserver<ModalRoute<void>>(),
    RouteObserver<ModalRoute<void>>(),
  ];

  Widget _buildTabNavigator({
    required GlobalKey<NavigatorState> navigatorKey,
    required RouteFactory onGenerateRoute,
    required RouteObserver observer,
  }) {
    return Navigator(
      key: navigatorKey,
      observers: [observer],
      onGenerateRoute: onGenerateRoute,
    );
  }

  void notifyTabVisibility(int index) {
    for (int i = 0; i < _navigatorKeys.length; i++) {
      final nav = _navigatorKeys[i].currentState;
      if (nav == null) continue;

      void checkElement(Element element) {
        final articleState = element
            .findAncestorStateOfType<Article_PageState>();
        articleState?.onTabVisibilityChanged(i == index);

        final followState = element
            .findAncestorStateOfType<Followed_PageState>();
        followState?.onTabVisibilityChanged(i == index);

        final statsState = element.findAncestorStateOfType<StatsState>();
        statsState?.onTabVisibilityChanged(i == index);

        element.visitChildren(checkElement);
      }

      nav.context.visitChildElements(checkElement);
    }
  }

  Route current_articlesRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Home_Page());

      case '/current_articles':
        return MaterialPageRoute(builder: (_) => CurrentArticles());

      case '/followed_articles':
        return MaterialPageRoute(
          builder: (_) =>
              Followed_Page(tab_index: 1, observer: _routeObservers[1]),
        );

      case '/loading':
        return MaterialPageRoute(settings: settings, builder: (_) => Loading());

      case '/article_page':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              Article_Page(tab_index: 1, observer: _routeObservers[1]),
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
        return MaterialPageRoute(settings: settings, builder: (_) => Loading());

      case '/article_page':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              Article_Page(tab_index: 0, observer: _routeObservers[0]),
        );

      default:
        throw Exception('Invalid route: ${settings.name}');
    }
  }

  Route misc_article_routes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MiscPage());
      case '/stats':
        return MaterialPageRoute(
          builder: (_) => Stats(tab_index: 2, observer: _routeObservers[2]),
        );
      case '/about':
        return MaterialPageRoute(builder: (_) => AboutPage());
      case '/masthead':
        return MaterialPageRoute(builder: (_) => MastHead_Page());
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
            observer: _routeObservers[0],
            onGenerateRoute: all_articlesRoutes,
          ),
          _buildTabNavigator(
            navigatorKey: _navigatorKeys[1],
            observer: _routeObservers[1],
            onGenerateRoute: current_articlesRoutes,
          ),
          _buildTabNavigator(
            navigatorKey: _navigatorKeys[2],
            observer: _routeObservers[2],
            onGenerateRoute: misc_article_routes,
          ),
          _buildTabNavigator(
            navigatorKey: _navigatorKeys[3],
            observer: _routeObservers[3],
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
            selectedIndex: page_index,
            gap: 6,
            backgroundColor: const Color.fromARGB(255, 10, 62, 105),
            color: const Color.fromARGB(255, 135, 135, 135),
            tabBackgroundColor: const Color.fromARGB(255, 14, 90, 152),
            textStyle: TextStyle(fontSize: 19, color: Colors.white),
            iconSize: 25,
            onTabChange: (index) {
              setState(() {
                page_index = index;
                notifyTabVisibility(index);
              });
            },
            tabs: const [
              GButton(icon: Icons.newspaper, text: "Articles"),
              GButton(icon: Icons.home, text: "Home"),
              GButton(icon: Icons.settings, text: "Personal"),
              GButton(icon: Icons.gamepad_sharp, text: "Games"),
            ],
          ),
        ),
      ),
    );
  }
}
