import 'package:flutter/material.dart';

class Back_From_Rec {
  String title;
  String author;
  Back_From_Rec({required this.author, required this.title});
}

class  RecommendCard extends StatelessWidget {
  final Back_From_Rec back_from_rec;
  const RecommendCard({required this.back_from_rec});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
                onPressed: (){
                  Navigator.pushReplacementNamed(context, '/loading', 
                  arguments:{
                    'title': back_from_rec.title,
                    'author': back_from_rec.author,
                  });
                }, 
                child: Text("Prev Article",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10
                )),);
  }

}