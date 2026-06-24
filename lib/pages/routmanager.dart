import 'package:The_Gilman_News/pages/gamespages/connectionloading.dart';
import 'package:The_Gilman_News/pages/miscpages/about.dart';
import 'package:The_Gilman_News/pages/miscpages/masthead_page.dart';
import 'package:The_Gilman_News/pages/miscpages/misc_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:The_Gilman_News/pages/articlepages/article_page.dart';
import 'package:The_Gilman_News/pages/articlepages/loading.dart';
import 'package:The_Gilman_News/pages/articlepages/all_articles.dart';
import 'package:The_Gilman_News/pages/homepages/currentarticles.dart';
import 'package:The_Gilman_News/pages/miscpages/stats.dart';
import 'package:The_Gilman_News/pages/homepages/home_page.dart';
import 'package:The_Gilman_News/pages/homepages/followed.dart';
import 'package:The_Gilman_News/pages/gamespages/games.dart';
import 'package:The_Gilman_News/pages/gamespages/connectiongame.dart';
import 'package:The_Gilman_News/pages/gamespages/connectionsselector.dart';
import 'package:The_Gilman_News/games/curling/curling_game.dart';
import 'package:The_Gilman_News/pages/miscpages/credits.dart'; // 6 or 7 imports
import 'package:The_Gilman_News/pages/homepages/author_catalogue.dart';
import 'package:The_Gilman_News/pages/homepages/author_profile_page.dart';
import 'package:The_Gilman_News/pages/articlepages/edition_viewer.dart';

class Route_Manager extends StatefulWidget {
  const Route_Manager({super.key});

  @override
  State<Route_Manager> createState() => _Route_ManagerState();
}

class _Route_ManagerState extends State<Route_Manager> {
  int page_index = 1;

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

        final allarticleState = element
            .findAncestorStateOfType<AllArticlesPageState>();
        allarticleState?.onTabVisibilityChanged(i == index);

        final currentarticleState = element
            .findAncestorStateOfType<CurrentArticlesState>();
        currentarticleState?.onTabVisibilityChanged(i == index);

        final authorcatState = element
            .findAncestorStateOfType<AuthorCatState>();
        authorcatState?.onTabVisibilityChanged(i == index);

        final authorprofileState = element
            .findAncestorStateOfType<AuthorProfilePageState>();
        authorprofileState?.onTabVisibilityChanged(i == index);

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
        return MaterialPageRoute(
          builder: (_) =>
              CurrentArticles(tab_index: 1, observer: _routeObservers[1]),
        );

      case '/author_catalogue':
        return MaterialPageRoute(
          builder: (_) => AuthorCat(tab_index: 1, observer: _routeObservers[1]),
        );

      case '/author_profile_page':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              AuthorProfilePage(tab_index: 1, observer: _routeObservers[1]),
        );

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

  Route game_tabroutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const Game());
      case '/connection':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Connections(),
        );
      case '/cloading':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Connectionloading(),
        );
      case '/cselector':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Connectionsselector(),
        );
      case '/curling':
        return MaterialPageRoute(builder: (_) => Curling());
      default:
        throw Exception('Invalid route: ${settings.name}');
    }
  }

  Route all_articlesRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              AllArticlesPage(tab_index: 0, observer: _routeObservers[0]),
        );

      case '/loading':
        return MaterialPageRoute(settings: settings, builder: (_) => Loading());

      case '/article_page':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              Article_Page(tab_index: 0, observer: _routeObservers[0]),
        );

      case '/edition_viewer':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) =>
              EditionViewer(tabindex: 0, observer: _routeObservers[0]),
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
      case '/credits':
        return MaterialPageRoute(builder: (_) => CreditsPage());
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
            onGenerateRoute: game_tabroutes,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 10, 62, 105),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: MediaQuery.of(
                context,
              ).textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.5),
            ), // Prevents over scaling
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: MediaQuery.of(
                  context,
                ).textScaler.clamp(maxScaleFactor: 1.5),
              ),
              child: GNav(
                selectedIndex: page_index,
                gap: 4,
                duration: Duration(milliseconds: 200),
                backgroundColor: const Color.fromARGB(255, 10, 62, 105),
                color: const Color.fromARGB(255, 135, 135, 135),
                tabBackgroundColor: const Color.fromARGB(255, 14, 90, 152),
                textStyle: TextStyle(fontSize: 16, color: Colors.white),
                iconSize: 20,
                onTabChange: (index) {
                  setState(() {
                    page_index = index;
                    notifyTabVisibility(index);
                  });
                },
                tabs: const [
                  GButton(icon: Icons.newspaper, text: "Articles"),
                  GButton(icon: Icons.home, text: "Home"),
                  GButton(icon: Icons.settings, text: "Misc"),
                  GButton(icon: Icons.gamepad_sharp, text: "Games"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
