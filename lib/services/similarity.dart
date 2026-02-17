import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/services/stats/algorithm.dart';

class Similarity_Finder {
  Topthree topthree = Topthree();
  
  double intersection(List one, List two) {
  Set set1 = Set.from(one);
  Set set2 = Set.from(two);
  Set intersectionSet = set1.intersection(set2);
  return intersectionSet.length/3;
  }

  Future getsimilarcategories(int id) async {
    final  data = await Supabase.instance.client.rpc(
    'get_related_articles', 
    params: {
    'target_article': id,  
    'max_results': 10    
  }, 
  );
  List catlist = await topthree.gettopthreecategories();
  List preferences = catlist.map((cat) => cat.name).toList();
  for (Map instance in data) {
    instance['match_score'] = instance['match_score']/3;
    List instance_cats = instance['Categories'];
    instance['match_score'] = instance['match_score'] + intersection(instance_cats , preferences );
    debugPrint(instance['match_score']);
  }
  }
}