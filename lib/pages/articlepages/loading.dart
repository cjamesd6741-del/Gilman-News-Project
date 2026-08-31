import 'package:The_Gilman_News/services/stats/articlestorage.dart';
import 'package:The_Gilman_News/services/stats/storage.dart';
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
  // Article Functions
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

  // Author Functions
  void get_author_data(String author) async {
    final Storedata _storedata = Storedata();
    final authorList = await _storedata.followed_author_reader();
    final bool original_state = authorList.contains(author);
    final author_json = await _getter.fetchAuthorJson(author);
    print(author_json);
    if (_cancelled || !mounted) return;
    push_to_author_page(author_json, original_state);
  }

  void push_to_author_page(Map input_author_json, bool followed) {
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
          'Class': input_author_json['Class'],
          'bio': input_author_json['bio'],
          'Image_Url': input_author_json['Image_urls'],
          'Position': input_author_json['Highest_Position'],
          'Initial_State': followed,
        },
      );
    }
  }

  // Article Of The Day Functions
  void get_article_of_day() async {
    Map<dynamic, dynamic> article = await _getter.fetch_article_of_the_day();
    push_to_article_of_the_daypage(
      article['json'],
      article['title'],
      article['author'],
    );
  }

  void push_to_article_of_the_daypage(Map inputjson, title, author) {
    print(title);
    print(author);
    if (!_cancelled && mounted) {
      Navigator.pushReplacementNamed(
        context,
        '/article_of_the_day',
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
          case 'article_of_the_day':
            get_article_of_day();
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
