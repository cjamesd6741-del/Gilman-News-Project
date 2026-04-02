import 'package:apitest_2/services/cardbuilder.dart';
import 'package:apitest_2/services/cardclass.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:apitest_2/services/globals.dart';
import 'package:apitest_2/services/cache.dart';

class AllArticleSearch extends SearchDelegate {
  List<ArticleWithReadStatus> articles;
  ValueNotifier<Set<int>> readnotifier;
  AllArticleSearch({required this.articles, required this.readnotifier});

  Timer? _debounce;
  String _debouncedQuery = '';

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

  void _onQueryChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 100), () {
      _debouncedQuery = query;
      query = query;
    });
  }

  @override
  void close(BuildContext context, result) {
    _debounce?.cancel();
    super.close(context, result);
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
    return ValueListenableBuilder<Set<int>>(
      valueListenable: Globals.globalReadArticlesNotifier,
      builder: (context, readArticles, _) {
        final q = _normalize(_debouncedQuery);

        final matches = articles
            .where((article) {
              final title = article.article.all;
              return title.contains(q);
            })
            .map((article) {
              return ArticleWithReadStatus(
                article: article.article,
                isRead: readArticles.contains(article.article.Article_ID),
              );
            })
            .toList();

        matches.sort((a, b) {
          return b.article.Date.compareTo(a.article.Date);
        });

        return ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, index) {
            return CurrentCardbuild(
              article: matches[index],
              onReturn: () async {
                final currentReads = Set<int>.from(readnotifier.value);
                if (!currentReads.contains(matches[index].article.Article_ID)) {
                  currentReads.add(matches[index].article.Article_ID);
                }
                readnotifier.value = currentReads;
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return ValueListenableBuilder<Set<int>>(
      valueListenable: readnotifier,
      builder: (context, readArticles, _) {
        final q = _normalize(_debouncedQuery);

        final matches = articles.where((article) {
          final title = article.article.all;
          return title.contains(q);
        }).toList();

        return ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final article = matches[index].article;
            debugPrint(readArticles.contains(article.Article_ID).toString());

            return CurrentCardbuild(
              article: ArticleWithReadStatus(
                article: article,
                isRead: readArticles.contains(article.Article_ID),
              ),
              onReturn: () async {
                final currentReads = Set<int>.from(readnotifier.value);
                if (!currentReads.contains(matches[index].article.Article_ID)) {
                  currentReads.add(matches[index].article.Article_ID);
                }
                readnotifier.value = currentReads;
              },
            );
          },
        );
      },
    );
  }
}
