import 'dart:collection';
import '/services/similarity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '/services/stats/Articlestorage.dart';
import '/services/appbartext.dart';
import '/services/back_from_rec.dart';
class Article_Page extends StatefulWidget {
  const Article_Page({super.key});

  @override
  State<Article_Page> createState() => _Article_PageState();
}

class _Article_PageState extends State<Article_Page> {
  Storedata storedata = Storedata();
  Textconfigure textconfigure = Textconfigure();
  TextStyle appbartextStyle = const TextStyle(fontSize: 18, height: 1.2);
  bool firstbuild = true;
  List categories = [];
  Stopwatch stopwatch = Stopwatch();
  List authorslist = [];
  String authors = '';
  Similarity_Finder similar = Similarity_Finder();
  int id = 0; 
  late Future<List<Similar_Instance>> recs;
  bool _initialized = false;
  String prevauthor = '';
  String prevtitle = '';
  bool recommended = false; //note this variable is only used to determine if the current article was pushed by an recommend button, in which case we create a way for the reader to go back


  Map data  = {};
  @override
  initState() {
    super.initState();
    storedata.updatearticleread();
    stopwatch.start();
    firstbuild = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map) {
      categories = args['category'] ?? [];
      storedata.categorywriter(categories);
      storedata.past10update(ListQueue.from(categories));
      authors = args['author'];
      authorslist = authors.split(RegExp(r',\s*|\s+and\s+'));
      debugPrint(authorslist.toString());
      storedata.authorwriter(authorslist);
      if (args['recommended'] == true){
        setState(() {
          recommended = true;
          prevauthor = args['prevauthor'];
          prevtitle = args['prevtitle'];
        });
      }
    }});
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map) {
        data = args;
        categories = args['category'] ?? [];
        authors = args['author'];
        id = args['id'];
        recs = similar.getsimilarcategories(id, authors , args['title'] );
      }
      _initialized = true;
    }
  }


  void onLeave() {
    stopwatch.stop();
    storedata.durationupdate(stopwatch.elapsed);
    firstbuild = false;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map) {
      data = args;
      }
    else {
      debugPrint('No arguments passed to Article_Page');
      return SpinKitCircle(
        color: const Color.fromARGB(255, 23, 69, 107),
        size: 50.0,
      );
    }
      final textStyle = appbartextStyle;
      final width = MediaQuery.of(context).size.width - 72;
      final double height = textconfigure.textHeight(width, data['title'] ?? 'Article', textStyle);
    if (firstbuild == true){
      categories = data['category'] ?? [];
      if (categories.isNotEmpty) {

      }
    }
  return PopScope(
    canPop: true,
      onPopInvokedWithResult: (didPop, result) {
    if (didPop) {
      onLeave();
    }},
    child: Scaffold(// actual layout
        appBar: AppBar(
          toolbarHeight: height + 80,
          actions: [
            if (recommended == true) RecommendCard(back_from_rec: Back_From_Rec(author: prevauthor, title: prevtitle)),], 
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(data['title'] ?? 'Article', 
              softWrap: true,
              maxLines: null,
              overflow: TextOverflow.visible,
              style: appbartextStyle
              ),
            const SizedBox(height: 12),
            ],
          ),
          
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(60.0, 16.0, 60.0, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                if (data['image_urls'] != null && (data['image_urls'] as List).length > 1) 
                SafeArea(
                  left: true,
                  right: true,
                  child: ClipRect(
                    child: CarouselSlider(
                      options: CarouselOptions(
                        viewportFraction: .95,
                        height: 500,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: true, 
                        autoPlay: false,
                        clipBehavior: Clip.hardEdge
                      ),
                        items: List.generate(
                        (data['image_urls'] as List).length,
                        (index) {
                          final url = data['image_urls'][index];
                          final labels = data['image_labels'] as List?;
                          return Column(
                            children: [
                              if (labels != null && index < labels.length) ...[
                                Text(
                                  labels[index] ?? "",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                    
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color.fromARGB(255, 9, 8, 50) , width: 5),
                                ),
                                child: Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  height: 350,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),// if there are multiple images, show a carousel
                if (data['image_urls'] != null && (data['image_urls'] as List).length == 1) 
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color.fromARGB(255, 9, 8, 50) , width: 5),
                          ),
                          child: Image.network(
                            data['image_urls'][0], 
                            fit: BoxFit.cover),
                        ),
                      ),
                      if (data['image_labels'] != null && (data['image_labels'] as List).isNotEmpty) 
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            data['image_labels'][0],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                Text(
                  'By ${data['author'] ?? ''} - ${data['date'] ?? ''}',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (data['words'] as List<dynamic>).map<Widget>((word) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        '       ${word.toString()}',
                        style: TextStyle(fontSize: 18, height: 1.5),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text("Recommended Articles" , style: TextStyle(
                  fontSize: 25 , color: const Color.fromARGB(255, 12, 67, 111)
                ),),
                FutureBuilder(
                  future: recs, 
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if( snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SpinKitCubeGrid(
                            color:  const Color.fromARGB(255, 2, 4, 88),
                            size: 75,
                          ),
                      );
                    }
                    if (!snapshot.hasData || snapshot.hasError) {
                      return Center(
                        child: SpinKitCubeGrid(
                            color: const Color.fromARGB(255, 2, 4, 88),
                            size: 75,
                          ),
                      );
                    }
                    List<Similar_Instance> recommendations = snapshot.data; 
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: recommendations.map((recommend) {
                        return Padding(
                          padding: const EdgeInsetsGeometry.fromLTRB(0, 15, 0, 0),
                          child: SimilarCard(similar_instance : recommend),
                        );
                      }).toList());
                  }
                  )
                ]
                )
          ),
        ),
      ),
  );
  }
}