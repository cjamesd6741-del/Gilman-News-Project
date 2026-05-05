import 'package:flutter/material.dart';

class Back_From_Rec {
  String title;
  String author;
  int ID;
  Back_From_Rec({required this.author, required this.title, required this.ID});
}

class RecommendCard extends StatelessWidget {
  final Back_From_Rec back_from_rec;
  final VoidCallback onleave;
  const RecommendCard({
    super.key,
    required this.back_from_rec,
    required this.onleave,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(),
      onPressed: () {
        onleave();
        Navigator.pushReplacementNamed(
          context,
          '/loading',
          arguments: {
            'title': back_from_rec.title,
            'author': back_from_rec.author,
            'ID': back_from_rec.ID,
          },
        );
      },
      child: Text(
        "Prev Article",
        style: TextStyle(color: Colors.black, fontSize: 10),
      ),
    );
  }
}
