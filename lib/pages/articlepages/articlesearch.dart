import 'package:The_Gilman_News/services/cardbuilder.dart';
import 'package:The_Gilman_News/services/cardclass.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:The_Gilman_News/services/globals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AllArticleSearch extends SearchDelegate {
  List<ArticleWithReadStatus> articles;
  ValueNotifier<Set<int>> readnotifier;
  AllArticleSearch({required this.articles, required this.readnotifier});

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
    return ValueListenableBuilder<Set<int>>(
      valueListenable: Globals.globalReadArticlesNotifier,
      builder: (context, readArticles, _) {
        final q = _normalize(query);

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
          return b.article.edition_num.compareTo(a.article.edition_num);
        });

        return ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, index) {
            return Other_Instances_Cardbuild(
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
    return ListenableBuilder(
      listenable: Listenable.merge([readnotifier, _debouncedQueryNotifier]),
      builder: (context, _) {
        final debouncedQueryText = _debouncedQueryNotifier.value;
        final readArticles = readnotifier.value;
        final q = _normalize(debouncedQueryText);
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
          return b.article.edition_num.compareTo(a.article.edition_num);
        });

        return ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final article = matches[index].article;

            return Other_Instances_Cardbuild(
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

class AllArticleTextSearch extends SearchDelegate {
  // as you can guess from the name, this moderates text search
  ValueNotifier<Set<int>> readnotifier;
  AllArticleTextSearch({required this.readnotifier});

  Timer? _debounce;
  Future _future = Future.value();
  String _debouncedQuery = '';
  String last_query = '';
  String clean_query = '';
  Future? results_future = null;
  final ValueNotifier<Future?> searched_query = ValueNotifier<Future?>(
    Future.value(),
  );

  void _debounceSearch(String textQuery) {
    final cleanQuery = textQuery.trim();
    if (cleanQuery == last_query) return; // Skip if query hasn't changed

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (cleanQuery.isEmpty) {
      searched_query.value = null;
      last_query = '';
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      searched_query.value = suggestion_card_retriever(cleanQuery);
    });
  }

  Future suggestion_card_retriever(String squery) async {
    final data = await Supabase.instance.client.rpc(
      'text_searcher',
      params: {'query': _normalize(squery), 'range': 20},
    );
    return data;
  }

  Future results_card_retriever(String rquery) async {
    final data = await Supabase.instance.client.rpc(
      'text_searcher',
      params: {'query': _normalize(rquery), 'range': 1000},
    );
    return data;
  }

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
  void close(BuildContext context, result) {
    _debounce?.cancel();
    super.close(context, result);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = ''; // resets the visual display
          _debounceSearch('');
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
    print(query);
    final cleanQuery = query.trim();
    print(last_query);
    if (cleanQuery != last_query || results_future == null) {
      print("true");
      results_future = results_card_retriever(cleanQuery);
      last_query = cleanQuery;
    }
    if (query == '') {
      return Center(
        child: Text(
          'Please Input a Query',
          style: GoogleFonts.lora(color: Colors.black, fontSize: 30),
        ),
      );
    }

    return FutureBuilder(
      future: results_future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        try {
          if (snapshot.data.isEmpty &&
              snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: Text(
                'No Results, Sorry',
                style: GoogleFonts.lora(color: Colors.black, fontSize: 30),
              ),
            );
          }
        } catch (error) {
          print(error);
        }
        if (!snapshot.hasData) {
          return SpinKitCircle(color: Colors.black, size: 50);
        }
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Error: ${snapshot.error}'),
          );
        }

        final List rawdata = snapshot.data;
        final articlelist = rawdata.map((article) {
          List<String> tag = [];
          try {
            tag = article['categories'].split(',');
            tag.map((e) {
              return e.trim();
            });
          } catch (_) {}

          return Article(
            Article_ID: article['id_number'],
            Article_Title: article['title_of_article'],
            author: article['Author'],
            Date: article['date'],
            edition_num: article['edition_num'],
            tags: tag,
          );
        }).toList();

        return ListView.builder(
          shrinkWrap: true,
          itemCount: articlelist.length,
          itemBuilder: (BuildContext context, int index) {
            final article = articlelist[index];
            return ValueListenableBuilder(
              valueListenable: readnotifier,
              builder: (context, read_articles, child) {
                ArticleWithReadStatus processedArticle = ArticleWithReadStatus(
                  article: article,
                  isRead: read_articles.contains(article.Article_ID),
                );

                return Padding(
                  padding: EdgeInsets.all(8),
                  child: Other_Instances_Cardbuild(
                    article: processedArticle,
                    onReturn: () async {
                      final currentReads = Set<int>.from(readnotifier.value);
                      if (!currentReads.contains(
                        articlelist[index].Article_ID,
                      )) {
                        currentReads.add(articlelist[index].Article_ID);
                      }
                      readnotifier.value = currentReads;
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _debounceSearch(query);
    if (query == '') {
      // quick check to prevent empty query
      return Center(
        child: Text(
          'Please Input a Query',
          style: GoogleFonts.lora(color: Colors.black, fontSize: 30),
        ),
      );
    }
    return ValueListenableBuilder(
      valueListenable: searched_query,
      builder: (BuildContext context, value, child) {
        if (value == null) {
          return SpinKitCircle(color: Colors.black, size: 50);
        }

        return FutureBuilder(
          future: value,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return SpinKitCircle(color: Colors.black, size: 50);
            }
            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error: ${snapshot.error}'),
              );
            }

            final List rawdata = snapshot.data;
            final articlelist = rawdata.map((article) {
              List<String> tag = [];
              try {
                tag = article['categories'].split(',');
                tag.map((e) {
                  return e.trim();
                });
              } catch (_) {}

              return Article(
                Article_ID: article['id_number'],
                Article_Title: article['title_of_article'],
                author: article['Author'],
                Date: article['date'],
                edition_num: article['edition_num'],
                tags: tag,
              );
            }).toList();

            return ListView.builder(
              shrinkWrap: true,
              itemCount: articlelist.length,
              itemBuilder: (BuildContext context, int index) {
                final article = articlelist[index];
                return ValueListenableBuilder(
                  valueListenable: readnotifier,
                  builder: (context, read_articles, child) {
                    ArticleWithReadStatus processedArticle =
                        ArticleWithReadStatus(
                          article: article,
                          isRead: read_articles.contains(article.Article_ID),
                        );

                    return Padding(
                      padding: EdgeInsets.all(8),
                      child: Other_Instances_Cardbuild(
                        article: processedArticle,
                        onReturn: () async {
                          final currentReads = Set<int>.from(
                            readnotifier.value,
                          );
                          if (!currentReads.contains(
                            articlelist[index].Article_ID,
                          )) {
                            currentReads.add(articlelist[index].Article_ID);
                          }
                          readnotifier.value = currentReads;
                        },
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
