import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double expandedHeight = max(screenHeight / 8, 100.0);
    final double collapsedHeight = max(screenHeight / 12, 60.0);
    final double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 158, 175, 206),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              title: Align(
                alignment: AlignmentGeometry.bottomCenter,
                child: Text(
                  "Games",
                  style: GoogleFonts.lora(fontSize: 40, color: Colors.white),
                ),
              ),
              backgroundColor: const Color.fromARGB(255, 30, 85, 131),
              elevation: 5,
              forceElevated: true,
              shadowColor: Colors.black,
              expandedHeight: expandedHeight,
              collapsedHeight: collapsedHeight,
              toolbarHeight: collapsedHeight,
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
                  Navigator.pushNamed(context, '/cselector');
                },
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 93, 131, 206),
                        Color.fromARGB(255, 3, 61, 112),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: AutoSizeText(
                      textAlign: TextAlign.center,
                      "Gilman Connections",
                      wrapWords: true,

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
            Material(
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.hardEdge,
              elevation: 4,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/curling');
                },
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 54, 8, 115),
                        Color.fromARGB(255, 3, 61, 112),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: SizedBox(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Curling",
                            softWrap: false,
                            style: GoogleFonts.lora(
                              fontSize: 22 + (width / 35),
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 196, 216, 234),
                            ),
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
