import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 215, 215, 215),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              centerTitle: true,
              backgroundColor: const Color.fromARGB(255, 34, 72, 92),
              title: Text(
                style: GoogleFonts.lora(color: Colors.white, fontSize: 30),
                "About The News",
              ),
              floating: true,
              forceElevated: true,

              elevation: 4.0,
              shadowColor: const Color.fromARGB(255, 0, 0, 0),
              expandedHeight: 100,
              collapsedHeight: 80,
            ),
          ];
        },
        body: SingleChildScrollView(
          child: InteractiveViewer(
            maxScale: 3,
            clipBehavior: Clip.none,
            panEnabled: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(26, 0, 26, 0),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  RichText(
                    text: TextSpan(
                      text: "      The ",
                      style: GoogleFonts.lora(
                        fontSize: 24,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: "Gilman News",
                          style: GoogleFonts.lora(
                            fontStyle: FontStyle.italic,
                            color: Color.fromARGB(255, 0, 75, 141),
                          ),
                        ),
                        TextSpan(
                          text:
                              " is a 103-year-old student-run newspaper at The Gilman School in Baltimore, Maryland. Our staff consists of high school students who meet during free periods to write, edit, and publish. Student editors and contributors run the process of publication from start to finish and are assisted by our faculty advisors.",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    text: TextSpan(
                      text: "      The News ",
                      style: GoogleFonts.lora(
                        fontSize: 24,
                        color: Color.fromARGB(255, 0, 75, 141),
                        fontStyle: FontStyle.italic,
                      ),
                      children: [
                        TextSpan(
                          text:
                              "seeks to create an intellectual atmosphere where aspiring and talented writers can cultivate journalistic skills and hone their writing. Our largest audience is the students of our school. As such, articles and features we publish should contain information and ideas of great interest to our student body. In addition, faculty, alumni, prospective students, and guests read our paper. It should be appropriate for all. ",
                          style: GoogleFonts.lora(
                            fontStyle: FontStyle.normal,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "The News ",
                          style: GoogleFonts.lora(fontStyle: FontStyle.italic),
                        ),
                        TextSpan(
                          text:
                              "is ultimately the students’ voice, and it should reflect student ideas, not faculty ones. ",
                          style: GoogleFonts.lora(
                            fontStyle: FontStyle.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    text: TextSpan(
                      text: "      Furthermore, ",
                      style: GoogleFonts.lora(
                        fontSize: 24,
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                      ),
                      children: [
                        TextSpan(
                          text: "The Gilman News",
                          style: GoogleFonts.lora(
                            fontStyle: FontStyle.italic,
                            color: Color.fromARGB(255, 0, 75, 141),
                          ),
                        ),
                        TextSpan(
                          text:
                              " is committed to upholding the highest standards of journalistic integrity and ethics. We strive to provide accurate, unbiased reporting while fostering a culture of open dialogue and critical thinking within our school community. Through our dedication to journalistic excellence, we aim to inspire our readers to engage thoughtfully with the issues and events shaping our world, both within and beyond the walls of our institution.",
                          style: GoogleFonts.lora(fontStyle: FontStyle.normal),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
