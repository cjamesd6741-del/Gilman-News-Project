import 'package:apitest_2/services/routes.dart';
import 'package:flutter/material.dart';
import 'package:apitest_2/services/stats/Articlestorage.dart';

class Followed_Page extends StatefulWidget {
  const Followed_Page({super.key});

  @override
  State<Followed_Page> createState() => _Followed_PageState();
}

class _Followed_PageState extends State<Followed_Page> with RouteAware {
  bool _isTabVisible = false;
  late List followed_authors;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            backgroundColor: const Color.fromARGB(255, 34, 72, 92),
            expandedHeight: 180,
            collapsedHeight: 80,
            pinned: true,
            flexibleSpace: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'lib/images/Followed_Authors.jpeg',
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
                              'Followed Author',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Articles',
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
          ),
        ];
      },
      body: SingleChildScrollView(
        child: Column(children: [const SizedBox(height: 1000), Text("6,7")]),
      ),
    );
  }
}
