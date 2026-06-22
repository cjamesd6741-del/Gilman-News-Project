import 'package:flutter/material.dart';
import 'package:The_Gilman_News/services/following_system.dart';
import 'package:google_fonts/google_fonts.dart';

class Author_Card extends StatelessWidget {
  final String author;
  final bool followed;
  final VoidCallback ontoggle;
  const Author_Card({
    super.key,
    required this.author,
    required this.followed,
    required this.ontoggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: const Color.fromARGB(255, 116, 127, 149),
      color: const Color.fromARGB(255, 46, 48, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: Color.fromARGB(255, 80, 83, 87),
          width: 4,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 10,
          children: [
            Text(
              author,
              style: const TextStyle(fontSize: 25, color: Colors.white),
            ),
            Follow_Card(author: author, followed: followed, ontoggle: ontoggle),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/loading',
                  arguments: {
                    'author': author,
                    "purpose":
                        "author", //I know its a bit confusing, reference loading page for some clarity
                  },
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [
                  Text(
                    "Learn More",
                    style: GoogleFonts.libreCaslonDisplay(color: Colors.white),
                  ),
                  Icon(Icons.arrow_right_alt, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
