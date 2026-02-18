import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'Articlestorage.dart';

class Topthree {
  Storedata catstorage = Storedata();
  Map data = {};
  String state = "";
  List<Category> topThree = [];
  List<Author> topThree_a = [];
  List recentCategories = [];

  Future<List<Category>> gettopthreecategories() async {
      String state = await catstorage.catstorage.filereader();
      if (state == 'didnt work') {
        debugPrint(state);
        return []; 
      }
      else {
        data = jsonDecode(state);
        Map<String, int> catcounts = Map<String, int>.from(data);
        var sortedEntries = catcounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        topThree = sortedEntries.take(3).map((e) => Category(name : e.key, count : e.value)).toList();
        return topThree;
      }
  }// return number of articles read

  Future<List<Category>> gettopthreerecentcategories() async {
    recentCategories = await catstorage.past10reader();
    Map<String, int> catcounts = {};
    for (var category in recentCategories) {
      catcounts[category] = (catcounts[category] ?? 0) + 1;
    }
    var sortedEntries = catcounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    topThree = sortedEntries.take(3).map((e) => Category(name : e.key, count : e.value)).toList();
    return topThree;
  }

  Future<List<Author>> gettopthreeauthors() async {
    Map authormap = await catstorage.authorreader();
    var sortedEntries = authormap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    topThree_a = sortedEntries.take(3).map((e) => Author(name : e.key, count : e.value)).toList();
    return topThree_a;
  }
  
}

class Category {
  String name;
  int count;
  Category({required this.name, required this.count});
}

class Author {
  String name;
  int count;
  Author({required this.name, required this.count});
}


class CategoryCard extends StatelessWidget {

  final Category category;
  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Card(
        child: ListTile(
          title: Text(category.name),
          trailing: Text(category.count.toString()),
        ),
      ),
    );
  }
}

class AuthorCard extends StatelessWidget {

  final Author author;
  const AuthorCard({super.key, required this.author});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Card(
        child: ListTile(
          title: Text(author.name),
          trailing: Text(author.count.toString()),
        ),
      ),
    );
  }
}
