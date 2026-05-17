import 'package:flutter/material.dart';
import 'package:The_Gilman_News/services/globals.dart';

class ConnectionSelector {
  String date;
  int id;
  double edition_num;
  ConnectionSelector({
    required this.date,
    required this.id,
    required this.edition_num,
  });
}

class ConnectionSelectorCard extends StatelessWidget {
  final ConnectionSelector connectioninfo;
  const ConnectionSelectorCard({super.key, required this.connectioninfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Card(
        elevation: 10,
        shadowColor: const Color.fromARGB(255, 116, 127, 149),
        color: const Color.fromARGB(255, 85, 85, 85),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: Color.fromARGB(255, 39, 46, 147),
            width: 4,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          splashColor: Colors.white,
          highlightColor: Colors.blueGrey,
          onTap: () async {
            if (Globals.clicked == false) {
              Globals.clicked = true;
              await Future.delayed(const Duration(milliseconds: 350));
              Navigator.of(
                context,
              ).pushNamed('/cloading', arguments: {'id': connectioninfo.id});
            }
            ;
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  connectioninfo.date,
                  style: const TextStyle(fontSize: 25, color: Colors.white),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
