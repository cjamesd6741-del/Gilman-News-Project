import 'package:apitest_2/services/stats/articlestorage.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/services/stats/algorithm.dart';
import 'package:apitest_2/services/cardclass.dart';

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

  Future<List<Article>> getsimilarcategories(
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
    List<Article> recommendedArticles = [];
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
          (e) => Article(
            Article_Title: e['title'],
            author: e['Author'],
            Article_ID: e["related_article_id"],
            Date: e['Date'],
            prevtitle: givenTitle,
            prevauthor: givenAuthor,
            edition_num: e['edition_num'] ?? 0.0,
          ),
        )
        .toList();
    return recommendedArticles;
  }
}
