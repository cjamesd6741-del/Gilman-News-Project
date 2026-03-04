import 'package:apitest_2/services/stats/articlestorage.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/services/stats/algorithm.dart';

class Similarity_Finder {
  Topthree topthree = Topthree();
  Storedata storedata = Storedata();

  double catintersection(List one, List two) {
    Set set1 = Set.from(one);
    Set set2 = Set.from(two);
    Set intersectionSet = set1.intersection(set2);
    return intersectionSet.length / 5;
  }

  double authprefintersection(List one, String databaseAuthor) {
    List two = databaseAuthor.split(RegExp(r',\s*|\s+and\s+'));
    Set set1 = Set.from(one);
    Set set2 = Set.from(two);
    Set intersectionSet = set1.intersection(set2);
    return intersectionSet.length / 8;
  }

  double followedprefintersection(List one, String databaseAuthor) {
    List two = databaseAuthor.split(RegExp(r',\s*|\s+and\s+'));
    Set set1 = Set.from(one);
    Set set2 = Set.from(two);
    Set intersectionSet = set1.intersection(set2);
    return intersectionSet.length / 6;
  }

  double authgivenintersection(String databaseAuthor, String givenAuthor) {
    List two = givenAuthor.split(RegExp(r',\s*|\s+and\s+'));
    List one = databaseAuthor.split(RegExp(r',\s*|\s+and\s+'));
    Set set1 = Set.from(one);
    Set set2 = Set.from(two);
    Set intersectionSet = set1.intersection(set2);
    return intersectionSet.length / 5;
  }

  Future<List<Similar_Instance>> getsimilarcategories(
    int id,
    String givenAuthor,
    String givenTitle,
  ) async {
    final data = await Supabase.instance.client.rpc(
      'get_related_articles',
      params: {'target_article': id, 'max_results': 20},
    );
    List catlist = await topthree.gettopthreecategories();
    List catpref = catlist.map((cat) => cat.name).toList();
    List<Similar_Instance> recommendedArticles = [];
    List<Map> allRecommendedArticles = [];

    List<Author> favauthors = await topthree.gettopthreeauthors();
    List followed_authors = await storedata.followed_author_reader();
    List authpref = favauthors.map((cat) => cat.name).toList();
    for (Map instance in data) {
      instance['match_score'] = instance['match_score'] / 3;
      List instanceCats = instance['Categories'];
      instance['match_score'] =
          instance['match_score'] +
          catintersection(instanceCats, catpref) +
          authprefintersection(authpref, instance['Author']) +
          authgivenintersection(instance['Author'], givenAuthor) +
          followedprefintersection(followed_authors, instance['Author']);
      allRecommendedArticles.add(instance);
    }
    allRecommendedArticles.sort((a, b) {
      return b['match_score'].compareTo(a['match_score']);
    });
    allRecommendedArticles = allRecommendedArticles.take(6).toList();
    allRecommendedArticles.shuffle();
    allRecommendedArticles = allRecommendedArticles.take(3).toList();
    recommendedArticles = allRecommendedArticles
        .map(
          (e) => Similar_Instance(
            title: e['title'],
            author: e['Author'],
            id: e["related_article_id"],
            date: e['Date'],
            prevtitle: givenTitle,
            prevauthor: givenAuthor,
          ),
        )
        .toList();
    return recommendedArticles;
  }
}

class Similar_Instance {
  String title;
  String author;
  String prevtitle;
  String prevauthor;
  String date;
  int id;
  Similar_Instance({
    required this.author,
    required this.id,
    required this.title,
    required this.prevtitle,
    required this.prevauthor,
    required this.date,
  });
}

class SimilarCard extends StatelessWidget {
  final Similar_Instance similar_instance;
  final VoidCallback onleave;
  const SimilarCard({
    super.key,
    required this.similar_instance,
    required this.onleave,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: const Color.fromARGB(255, 46, 48, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: Color.fromARGB(255, 204, 214, 219),
            width: 5,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          splashColor: Colors.white,
          highlightColor: Colors.blueGrey,
          onTap: () async {
            await Future.delayed(const Duration(milliseconds: 350));
            onleave();
            Navigator.pushReplacementNamed(
              context,
              '/loading',
              arguments: {
                'title': similar_instance.title,
                'author': similar_instance.author,
                'recommended': true,
                'prevauthor': similar_instance.prevauthor,
                'prevtitle': similar_instance.prevtitle,
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  similar_instance.title,
                  style: const TextStyle(
                    fontSize: 25,
                    color: Color.fromARGB(255, 211, 211, 211),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  similar_instance.author,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                    color: Color.fromARGB(255, 211, 211, 211),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  similar_instance.date,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 10,
                    color: Color.fromARGB(255, 211, 211, 211),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
