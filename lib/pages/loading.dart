import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/jsongenerator.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
    Map data = {};
    bool recommended = false;
    Future <void> getData(String author , String title) async{
      final articlejsonjson = await Getter(author: author, title: title).fetchArticleJson();
      Map ajstring = articlejsonjson;

      final articlejson = ajstring;
      push(articlejson,  author,  title);
      }

    void push(Map inputjson, String author, String title) {
      Navigator.pushReplacementNamed(
        context, '/article_page', arguments: {
          'words': inputjson['body'],
          'title': title,
          'author': author,
          'date': inputjson['date'],
          'category': inputjson['category'],
          'image_urls': inputjson['Image_urls'],
          'image_labels': inputjson['Image_label'],
          'id' : inputjson['id'],
          'recommended' : recommended,
          'prevauthor' : data["prevauthor"],
          'prevtitle' : data["prevtitle"],
        });
    }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map) {
        data = args;
        recommended = data["recommended"] ?? false;
        getData(
          data['author'] as String,
          data['title'] as String,
        );
      }});
      }




  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SpinKitFadingCircle(
              color: Colors.blue,
              size: 50.0,
            ),
          ),
        ],
      ),
    );


  }
}