import 'package:flutter/material.dart';
import '/services/stats/Articlestorage.dart';
import '/services/stats/algorithm.dart';

class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  int articlesRead = 0;
  Duration duration = Duration.zero;
  Duration shownduration = Duration.zero;
  int articler = 0;
  Storedata storedata = Storedata();
  Topthree topthree = Topthree();
  List<Category> topthreecategorieslist = [];
  List<Category> recentcategorieslist = [];


  Future getdata() async {
    articlesRead = await storedata.numarticleread();
    duration =  await storedata.durationreader();
    topthreecategorieslist = await topthree.gettopthreecategories();
    recentcategorieslist = await topthree.gettopthreerecentcategories();
    setState(() {
      articler = articlesRead;
      debugPrint(articler.toString());
      shownduration = Duration(seconds: duration.inSeconds);
      topthreecategorieslist = topthreecategorieslist;
      recentcategorieslist = recentcategorieslist;
    });
  }
  @override
  initState() {
    super.initState();
    getdata();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 55, 109, 138),
      body : NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [SliverAppBar(
              centerTitle: true,
              backgroundColor: const Color.fromARGB(255, 34, 72, 92),
              title:  const Text('Your Stats' , style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600 , color : Color.fromARGB(255, 216, 214, 214)),), 
              floating: true,
              forceElevated: innerBoxIsScrolled,
              expandedHeight: 180,
              collapsedHeight: 80,
            ),
          ];
        }, 
        body: Center(
          child: ListView(
            children: [ 
              Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const SizedBox(height: 30),
              Text('Articles Read: $articler' , style: const TextStyle(fontSize: 22 , fontWeight: FontWeight.w400 , color:  Colors.white54),),
              const SizedBox(height: 30),
              Text('Reading Duration: $shownduration' , style: const TextStyle(fontSize: 22 , fontWeight: FontWeight.w400 , color:  Colors.white54),),
              const SizedBox(height: 30),
              Text  ('Top Categories:' , style: const TextStyle(fontSize: 22 , fontWeight: FontWeight.w400 , color:  Color.fromARGB(255, 255, 249, 249)),),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: topthreecategorieslist.length,
                itemBuilder: (context, index) {
                  return CategoryCard(category: topthreecategorieslist[index]);
                },
              ),
              const SizedBox(height: 30),
              Text  ('Top Recent Categories:' , style: const TextStyle(fontSize: 22 , fontWeight: FontWeight.w400 , color:  Color.fromARGB(255, 255, 249, 249)),),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentcategorieslist.length,
                itemBuilder: (context, index) {
                  return CategoryCard(category: recentcategorieslist[index]);
                },
              )

            ],
        )],),
        ),
    ));
  }
}