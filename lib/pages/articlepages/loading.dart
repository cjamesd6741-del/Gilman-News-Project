import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../services/jsongenerator.dart';
import 'package:The_Gilman_News/services/globals.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Getter _getter = Getter();
  Map data = {};
  bool recommended = false;
  bool _cancelled = false;

  void get_article_Data(String author, String title, int id) async {
    final articlejsonjson = await _getter.fetchArticleJson(id);
    if (_cancelled || !mounted) return;
    Map ajstring = articlejsonjson;
    final articlejson = ajstring;
    push_to_article_page(articlejson, author, title);
  }

  void push_to_article_page(Map inputjson, String author, String title) {
    if (!_cancelled && mounted) {
      Navigator.pushReplacementNamed(
        context,
        '/article_page',
        arguments: {
          'words': inputjson['body'],
          'title': title,
          'author': author,
          'date': inputjson['date'],
          'category': inputjson['category'],
          'image_urls': inputjson['Image_urls'],
          'image_labels': inputjson['Image_label'],
          'id': inputjson['id'],
          'recommended': recommended,
          'prevauthor': data["prevauthor"],
          'prevtitle': data["prevtitle"],
          'prevID': data['prevID'],
        },
      );
    }
  }

  void get_author_data(String author) async {
    final author_json = await _getter.fetchAuthorJson(author);
    print(author_json);
    if (_cancelled || !mounted) return;
    push_to_author_page(author_json);
  }

  void push_to_author_page(Map input_author_json) {
    if (!_cancelled && mounted) {
      Navigator.pushReplacementNamed(
        context,
        '/author_profile_page',
        arguments: {
          'author': input_author_json['Author'],
          'num_of_articles': input_author_json['Num_Of_Articles'],
          'num_of_collabs': input_author_json['Num_Of_Collabs'],
          'authid': input_author_json['Auth_ID'],
          'first_article': input_author_json['first_article'],
          'last_article': input_author_json['last_article'],
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Globals.clicked = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map) {
        data =
            args; // useless line of code : remove eventually but do need to make some changes
        recommended = data["recommended"] ?? false;
        switch (data["purpose"] ?? 'article') {
          // the ?? 'article' sets default to article to make my life easier but I will probably eventually just explicitly name the argument for newer instances and so new people can read it easily
          case 'article':
            get_article_Data(
              data['author'] as String,
              data['title'] as String,
              data['ID'] as int,
            );
          case 'author':
            print('author load initialized');
            get_author_data(data['author']);
        }
      }
    });
  }

  void leave() {
    _cancelled = true; // prevents stale widget building
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (pop, result) {
        if (pop) return;
        leave();
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            leave();
          },
          backgroundColor: Colors.blue,
          child: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: SpinKitFadingCircle(color: Colors.blue, size: 50.0)),
          ],
        ),
      ),
    );
  }
}
