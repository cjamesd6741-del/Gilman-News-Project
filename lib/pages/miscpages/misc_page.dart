import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class MiscPage extends StatelessWidget {
  const MiscPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double expandedHeight = max(screenHeight / 8, 100.0);
    final double collapsedHeight = max(screenHeight / 12, 70.0);
    final double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 158, 175, 206),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              elevation: 10.0,
              backgroundColor: const Color.fromARGB(255, 30, 85, 131),
              expandedHeight: expandedHeight,
              collapsedHeight: collapsedHeight,
              toolbarHeight: collapsedHeight,
              pinned: true,
              floating: true,
              forceElevated: true,
              shadowColor: Colors.black,
              flexibleSpace: Stack(
                children: [
                  FlexibleSpaceBar(
                    background: Image.asset(
                      'lib/images/MiscPage.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      width: double.infinity,
                      height: double.infinity,
                      color: innerBoxIsScrolled
                          ? const Color.fromARGB(255, 30, 85, 131)
                          : Colors.transparent,
                      child: SafeArea(
                        child: Align(
                          alignment: AlignmentGeometry.center,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 40),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 100),
                                style: TextStyle(
                                  fontSize: 33,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                child: Text('Miscellaneous'),
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
        },
        body: GridView.count(
          padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            Material(
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.hardEdge,
              elevation: 4,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/stats');
                },
                child: Ink(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/images/Stats.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Center(
                        child: Text(
                          "Stats",
                          style: GoogleFonts.lora(
                            fontSize: 22 + (width / 35),
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Material(
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.hardEdge,
              elevation: 4,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/masthead');
                },
                child: Ink(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/images/Masthead.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Center(
                        child: Text(
                          "Masthead",
                          style: GoogleFonts.lora(
                            fontSize: 22 + (width / 35),
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 75, 141),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Material(
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.hardEdge,
              elevation: 4,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/about');
                },
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 25, 112, 188),
                        Color.fromARGB(255, 1, 53, 100),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Center(
                        child: Text(
                          "About",
                          style: GoogleFonts.lora(
                            fontSize: 22 + (width / 35),
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Material(
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.hardEdge,
              elevation: 4,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/credits');
                },
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 118, 119, 120),
                        Color.fromARGB(255, 78, 77, 77),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                    child: FittedBox(
                      // praise the fitted box, praise it!
                      fit: BoxFit.scaleDown,
                      child: Center(
                        child: Text(
                          "Licenses",
                          style: GoogleFonts.lora(
                            fontSize: 22 + (width / 35),
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
