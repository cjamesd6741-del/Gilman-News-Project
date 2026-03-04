import 'package:flutter/material.dart';

class Searchclass {
  final String searcharticletitle;
  final String searchauthor;
  final String searchdate;
  final double edition_num;
  Searchclass({
    required this.searcharticletitle,
    required this.searchauthor,
    required this.searchdate,
    required this.edition_num,
  });
}

class SearchCard extends StatelessWidget {
  final Searchclass searchclass;
  const SearchCard({super.key, required this.searchclass});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 46, 48, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: Color.fromARGB(255, 204, 214, 219),
          width: 5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        splashColor: Colors.white,
        highlightColor: Colors.blueGrey,
        onTap: () async {
          await Future.delayed(const Duration(milliseconds: 350));
          Navigator.of(context).pushNamed(
            '/loading',
            arguments: {
              'title': searchclass.searcharticletitle,
              'author': searchclass.searchauthor,
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                searchclass.searcharticletitle,
                style: const TextStyle(
                  fontSize: 25,
                  color: Color.fromARGB(255, 211, 211, 211),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                searchclass.searchauthor,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                  color: Color.fromARGB(255, 211, 211, 211),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                searchclass.searchdate,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 10,
                  color: Color.fromARGB(255, 211, 211, 211),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
