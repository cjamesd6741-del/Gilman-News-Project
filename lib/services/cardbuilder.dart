import 'package:apitest_2/services/cardclass.dart';
import 'package:flutter/material.dart';

class  Cardbuild extends StatelessWidget {
  final Cardclass cardclass;
  const Cardbuild({required this.cardclass});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
              ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/loading', 
                  arguments:{
                    'title': cardclass.articleTitle,
                    'author': cardclass.author,
                  });
                }, 
                child: Column(
                  children: [
                    Text(cardclass.articleTitle),
                    const SizedBox(width: 30),
                    Text(cardclass.author , style :TextStyle(fontStyle: FontStyle.italic)),
                    const SizedBox(width: 30),
                  ],
                ))
        ],
      ),

    );
  }
}

class  CurrentCardbuild extends StatelessWidget {
  final CurrentCardclass currentcardclass;
  const CurrentCardbuild({required this.currentcardclass});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
              ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/loading', 
                  arguments:{
                    'title': currentcardclass.articleTitle,
                    'author': currentcardclass.author,
                  });
                }, 
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(currentcardclass.articleTitle),
                    const SizedBox(width: 30),
                    Text(currentcardclass.author , style :TextStyle(fontStyle: FontStyle.italic)),
                    const SizedBox(width: 30),
                    Text(currentcardclass.date),
                    const SizedBox(width: 30),
                  ],
                ))
        ],
      ),

    );
  }

}