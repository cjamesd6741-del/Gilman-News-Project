import 'package:flutter/material.dart';
import '../services/searchclass.dart';

class AllArticleSearch extends SearchDelegate {
  List<Searchclass> articles;
  AllArticleSearch({required this.articles});

  String _normalize(String s) {
    return s
        .toLowerCase()
        .replaceAll('’', "'")
        .replaceAll('‘', "'")
        .replaceAll('“', '"')
        .replaceAll('”', '"')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final q = _normalize(query);
    final matches = articles.where((article) {
      final title = _normalize(article.searcharticletitle);
      final author = _normalize(article.searchauthor);
      final date = _normalize(article.searchdate);
      return title.contains(q) || author.contains(q) || date.contains(q);
    }).toList();

    matches.sort((a, b) {
      return b.searchdate.compareTo(a.searchdate);
    });

    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        var article = matches[index];
        return SearchCard(searchclass: article);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final q = _normalize(query);
    final matches = articles.where((article) {
      final title = _normalize(article.searcharticletitle);
      final author = _normalize(article.searchauthor);
      final date = _normalize(article.searchdate);
      return title.contains(q) || author.contains(q) || date.contains(q);
    }).toList();

    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        var article = matches[index];
        return SearchCard(searchclass: article);
      },
    );
  }
}
