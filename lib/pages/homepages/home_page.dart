import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/services/appbartext.dart';
import 'dart:math';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  TextStyle appbartextStyle = const TextStyle(fontSize: 40, height: 1.5);
  Textconfigure textconfigure = Textconfigure();
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double expandedHeight = max(screenHeight / 8, 100.0);
    final double collapsedHeight = max(screenHeight / 12, 70.0);
    final width = MediaQuery.sizeOf(context).width - 72;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 158, 175, 206),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerboxisscrolled) {
          return [
            SliverAppBar(
              forceElevated: true,
              pinned: true,
              centerTitle: true,
              elevation: 4.0,
              automaticallyImplyLeading: false,
              toolbarHeight: collapsedHeight,
              expandedHeight: expandedHeight,
              collapsedHeight: collapsedHeight,
              shadowColor: Colors.black,
              title: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                child: SizedBox(
                  height: collapsedHeight - 10,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: collapsedHeight - 10,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Image.asset("lib/images/Header.png"),
                          ),
                        ),
                        Text(
                          "The",
                          softWrap: true,
                          maxLines: null,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 80,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "News",
                          softWrap: true,
                          maxLines: null,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 80,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              backgroundColor: const Color.fromARGB(255, 30, 85, 131),
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
              clipBehavior: Clip.hardEdge, // clips everything inside
              elevation: 4, // optional shadow
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/current_articles');
                },
                child: Ink(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/images/gilmanschool2.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: AutoSizeText(
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      "Current Articles",
                      style: GoogleFonts.lora(
                        fontSize: 18 + (width / 35),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                  Navigator.pushNamed(context, '/followed_articles');
                },
                child: Ink(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/images/Followed_Authors.jpeg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: AutoSizeText(
                      textAlign: TextAlign.center,
                      "Followed Author Articles",
                      style: GoogleFonts.lora(
                        fontSize: 18 + (width / 35),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                  Navigator.pushNamed(context, '/author_catalogue');
                },
                child: Ink(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "lib/images/Author_Catalogue.png",
                      ), // I know I spelled it wrong now
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: AutoSizeText(
                      textAlign: TextAlign.center,
                      "Author Catalog",
                      style: GoogleFonts.lora(
                        fontSize: 18 + (width / 35),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                  Navigator.pushNamed(
                    context,
                    '/loading',
                    arguments: {'purpose': 'article_of_the_day'},
                  );
                },
                child: Ink(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/images/Article_Of_The_Day.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: AutoSizeText(
                      textAlign: TextAlign.center,
                      "Article Of The Day",
                      style: GoogleFonts.lora(
                        fontSize: 18 + (width / 35),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
