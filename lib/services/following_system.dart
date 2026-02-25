import 'package:flutter/material.dart';
import 'package:apitest_2/services/stats/Articlestorage.dart';
import 'package:google_fonts/google_fonts.dart';

class Follow_Card extends StatefulWidget {
  String author;
  bool followed;  
  Follow_Card({super.key, required this.author , required this.followed});

  @override
  State<Follow_Card> createState() => _Follow_CardState(author: author , followed: followed);
}

class _Follow_CardState extends State<Follow_Card> {
  String author;
  bool followed;
  _Follow_CardState({required this.author , required this.followed});

  @override
  Widget build(BuildContext context) {
  Storedata storedata = Storedata();
    if(!followed) {
      return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      ),
        onPressed: (){
          storedata.add_new_followed_author(author);
          setState((){
            followed = true;
          });
        }, 
        child: Text("follow" , style: GoogleFonts.tinos( fontStyle: FontStyle.italic , color: const Color.fromARGB(255, 13, 33, 94) , fontSize: 15)));
    }
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
      ),
      onPressed: (){
        storedata.remove_new_followed_author(author);
        setState((){
            followed = false;
        });
      }, 
      child: Text("unfollow" , style: GoogleFonts.tinos( fontStyle: FontStyle.italic , color: Colors.white , fontSize: 15)), );
  }
}