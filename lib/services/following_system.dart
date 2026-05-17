import 'package:flutter/material.dart';
import 'package:The_Gilman_News/services/stats/Articlestorage.dart';
import 'package:google_fonts/google_fonts.dart';

class Follow_Card extends StatelessWidget {
  final String author;
  final bool followed;
  final VoidCallback ontoggle;
  Follow_Card({
    super.key,
    required this.author,
    required this.followed,
    required this.ontoggle,
  });

  @override
  Widget build(BuildContext context) {
    Storedata storedata = Storedata();
    return Stack(
      children: [
        if (!followed)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 189, 189, 189),
              side: BorderSide(width: 2, color: Color.fromARGB(255, 9, 9, 85)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(16),
              ),
            ),

            onPressed: () {
              storedata.add_new_followed_author(author);
              ontoggle();
            },
            child: Text(
              "Follow",
              style: GoogleFonts.tinos(
                fontStyle: FontStyle.italic,
                color: const Color.fromARGB(255, 13, 33, 94),
                fontSize: 15,
              ),
            ),
          )
        else
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 12, 13, 60),
              side: BorderSide(width: 2, color: Color.fromARGB(255, 9, 9, 85)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(16),
              ),
            ),
            onPressed: () {
              storedata.remove_new_followed_author(author);
              ontoggle();
            },
            child: Text(
              "Unfollow",
              style: GoogleFonts.tinos(
                fontStyle: FontStyle.italic,
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
      ],
    );
  }
}
