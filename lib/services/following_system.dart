import 'package:flutter/material.dart';
import 'package:The_Gilman_News/services/stats/Articlestorage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:The_Gilman_News/services/globals.dart';

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
              final currentFollows = Globals.followedAuthorNotifier.value;
              Globals.followedAuthorNotifier.value = Set.from(currentFollows)
                ..add(author);
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
              final currentFollows = Globals.followedAuthorNotifier.value;
              Globals.followedAuthorNotifier.value = Set.from(currentFollows)
                ..remove(author);
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

class Big_Follow_Card extends StatelessWidget {
  final String author;
  final bool followed;
  final VoidCallback ontoggle;
  Big_Follow_Card({
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
          SizedBox(
            width: MediaQuery.sizeOf(context).width / 2,
            child: FittedBox(
              fit: BoxFit.fill,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 189, 189, 189),
                  side: BorderSide(
                    width: 3,
                    color: Color.fromARGB(255, 9, 9, 85),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                ),

                onPressed: () {
                  storedata.add_new_followed_author(author);
                  final currentFollows = Globals.followedAuthorNotifier.value;
                  Globals.followedAuthorNotifier.value = Set.from(
                    currentFollows,
                  )..add(author);
                  ontoggle();
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Follow !",
                    style: GoogleFonts.spaceMono(
                      fontStyle: FontStyle.italic,
                      color: const Color.fromARGB(255, 13, 33, 94),
                      fontSize: 35,
                    ),
                  ),
                ),
              ),
            ),
          )
        else
          SizedBox(
            width: MediaQuery.sizeOf(context).width / 2,
            child: FittedBox(
              fit: BoxFit.fill,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 12, 13, 60),
                  side: BorderSide(
                    width: 3,
                    color: Color.fromARGB(255, 210, 210, 233),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                ),
                onPressed: () {
                  storedata.remove_new_followed_author(author);
                  final currentFollows = Globals.followedAuthorNotifier.value;
                  Globals.followedAuthorNotifier.value = Set.from(
                    currentFollows,
                  )..remove(author);
                  ontoggle();
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Unfollow",
                    style: GoogleFonts.spaceMono(
                      // if your wondering why I chose this font, its because its monospaced so I didnt have to write a bunch of extra code to prevent jiggling
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontSize: 35,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
