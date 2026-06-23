import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:The_Gilman_News/services/globals.dart';
import 'package:The_Gilman_News/services/author.card.dart';

class Author_Search extends SearchDelegate {
  List<String?> authors;
  ValueListenable follow_changes;
  Author_Search({required this.authors, required this.follow_changes});

  Timer? _debounce;
  String _debouncedQuery = '';
  final ValueNotifier<String> _debouncedQueryNotifier = ValueNotifier<String>(
    '',
  );

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
      _debouncedQueryNotifier.value = query;
    });
  }

  @override
  void close(BuildContext context, result) {
    _debounce?.cancel();
    _debouncedQueryNotifier.dispose();
    super.close(context, result);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          _debouncedQueryNotifier.value = ''; // resets actual search
          query = ''; // resets the visual display
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
    return ValueListenableBuilder<Set<String>>(
      valueListenable: Globals.followedAuthorNotifier, //unecessary
      builder: (context, followed_authors, _) {
        final folAuths = followed_authors;
        final q = _normalize(query);

        final matches = authors.where((author) {
          final authorName = _normalize(author ?? '');
          return authorName.contains(q);
        }).toList();

        matches.sort((a, b) {
          return (a ?? '').compareTo(b ?? ''); //ascending alphabetization
        });

        return ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final author = matches[index] ?? '';
            return Author_Card(
              author: author,
              followed: folAuths.contains(author),
              ontoggle: () {},
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return ListenableBuilder(
      listenable: Listenable.merge([_debouncedQueryNotifier, follow_changes]),
      builder: (context, _) {
        final folAuths = follow_changes.value;
        final debouncedQueryText = _debouncedQueryNotifier.value;
        final q = _normalize(debouncedQueryText);
        final matches = authors.where((author) {
          final authorName = _normalize(author ?? '');
          return authorName.contains(q);
        }).toList();

        matches.sort((a, b) {
          return (a ?? '').compareTo(b ?? ''); //ascending alphabetization
        });

        return ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final author = matches[index] ?? '';
            return Author_Card(
              author: author,
              followed: folAuths.contains(author),
              ontoggle: () {},
            );
          },
        );
      },
    );
  }
}
