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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 158, 175, 206),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              title: Text(
                "Games",
                style: GoogleFonts.lora(fontSize: 40, color: Colors.white),
              ),
              backgroundColor: const Color.fromARGB(255, 30, 85, 131),
              elevation: 5,
              forceElevated: true,
              shadowColor: Colors.black,
              expandedHeight:
                  MediaQuery.sizeOf(context).height / 8, //8 is the standard
              collapsedHeight: max(MediaQuery.sizeOf(context).height / 12, 60),
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Material(
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.hardEdge,
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/cselector');
                  },
                  child: Ink(
                    height: 300,
                    width: MediaQuery.of(context).size.width - 30,
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
                          fontSize: 50,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Material(
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.hardEdge,
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/curling');
                  },
                  child: Ink(
                    height: 300,
                    width: MediaQuery.of(context).size.width - 30,
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
                      child: Padding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                        child: AutoSizeText(
                          "Curling",
                          style: GoogleFonts.lora(
                            fontSize: 50,
                            color: Color.fromARGB(255, 196, 216, 234),
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
      ),
    );
  }
}
