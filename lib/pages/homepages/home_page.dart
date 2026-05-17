import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/services/appbartext.dart';

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
    final width = MediaQuery.sizeOf(context).width - 72;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 158, 175, 206),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerboxisscrolled) {
          return [
            SliverAppBar(
              forceElevated: true,
              centerTitle: true,
              elevation: 4.0,
              shadowColor: Colors.black,
              toolbarHeight: MediaQuery.sizeOf(context).height / 8,
              flexibleSpace: FlexibleSpaceBar(
                title: FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: EdgeInsetsGeometry.fromLTRB(20, 10, 20, 30),
                    child: AutoSizeText(
                      "The Gilman News",
                      softWrap: true,
                      maxLines: null,
                      style: GoogleFonts.lora(
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              backgroundColor: const Color.fromARGB(255, 8, 53, 90),
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
                clipBehavior: Clip.hardEdge, // clips everything inside
                elevation: 4, // optional shadow
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/current_articles');
                  },
                  child: Ink(
                    height: 300,
                    width: MediaQuery.sizeOf(context).width - 30,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("lib/images/gilmanschool2.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Current",
                          style: GoogleFonts.libreCaslonText(
                            fontSize: 50,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Articles",
                          style: GoogleFonts.libreCaslonText(
                            fontSize: 50,
                            color: Colors.white,
                          ),
                        ),
                      ],
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
                    Navigator.pushNamed(context, '/followed_articles');
                  },
                  child: Ink(
                    height: 300,
                    width: MediaQuery.sizeOf(context).width - 30,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("lib/images/Followed_Authors.jpeg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Followed Authors",
                            style: GoogleFonts.libreCaslonText(
                              fontSize: 40,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Articles",
                            style: GoogleFonts.libreCaslonText(
                              fontSize: 40,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
