
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/services/stats/algorithm.dart';

class Similarity_Finder {

  Topthree topthree = Topthree();
  
  double catintersection(List one, List two) {
  Set set1 = Set.from(one);
  Set set2 = Set.from(two);
  Set intersectionSet = set1.intersection(set2);
  return intersectionSet.length/5;
  }

  double authprefintersection(List one, String database_author) {
  List two = database_author.split(RegExp(r',\s*|\s+and\s+'));
  Set set1 = Set.from(one);
  Set set2 = Set.from(two);
  Set intersectionSet = set1.intersection(set2);
  return intersectionSet.length/8;
  }

  double authgivenintersection(String database_author, String given_author) {
  List two = given_author.split(RegExp(r',\s*|\s+and\s+'));
  List one = database_author.split(RegExp(r',\s*|\s+and\s+'));
  Set set1 = Set.from(one);
  Set set2 = Set.from(two);
  Set intersectionSet = set1.intersection(set2);
  return intersectionSet.length/5;
  }

  Future<List<Similar_Instance>> getsimilarcategories(int id , String given_author , String given_title) async {
    final  data = await Supabase.instance.client.rpc(
    'get_related_articles', 
    params: {
    'target_article': id,  
    'max_results': 20    
  }, 
  );
    List catlist = await topthree.gettopthreecategories();
    List catpref = catlist.map((cat) => cat.name).toList();
    List<Similar_Instance> recommended_articles = [];
    List<Map> all_recommended_articles = [];

    List<Author> favauthors = await topthree.gettopthreeauthors();
    List authpref = favauthors.map((cat) => cat.name).toList();
    for (Map instance in data) {
      instance['match_score'] = instance['match_score']/3;
      List instance_cats = instance['Categories'];
      instance['match_score'] = instance['match_score'] + catintersection(instance_cats , catpref) + authprefintersection(authpref, instance['Author']) + authgivenintersection(instance['Author'], given_author);
      all_recommended_articles.add(instance);
    }
    all_recommended_articles.sort((a, b) {
      return b['match_score'].compareTo(a['match_score']);
    });
    all_recommended_articles = all_recommended_articles.take(6).toList();
    all_recommended_articles.shuffle();
    all_recommended_articles = all_recommended_articles.take(3).toList();
    recommended_articles = all_recommended_articles.map((e) => Similar_Instance(title: e['title'] , author: e['Author'] , id: e["related_article_id"] ,prevtitle: given_title  , prevauthor: given_author )).toList();
    return recommended_articles;
  }
}



class Similar_Instance {
  String title;
  String author;
  String prevtitle;
  String prevauthor;
  int id;
  Similar_Instance({required this.author , required this.id , required this.title, required this.prevtitle , required this.prevauthor});
}

class  SimilarCard extends StatelessWidget {
  final Similar_Instance similar_instance;
  VoidCallback onleave;
  SimilarCard({required this.similar_instance , required this.onleave});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
              ElevatedButton(
                onPressed: (){
                  onleave();
                  Navigator.pushReplacementNamed(context, '/loading', 
                  arguments:{
                    'title': similar_instance.title,
                    'author': similar_instance.author,
                    'recommended' : true,
                    'prevauthor' : similar_instance.prevauthor,
                    'prevtitle' : similar_instance.prevtitle,
                  });
                }, 
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(similar_instance.title, style : TextStyle(fontSize: 20)),
                    const SizedBox(width: 30),
                    Text(similar_instance.author , style :TextStyle(fontStyle: FontStyle.italic , fontSize: 12)),
                    const SizedBox(width: 30),
                  ],
                ))
        ],
      ),
    );
  }

}