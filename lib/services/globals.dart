import 'package:flutter/material.dart';
import 'package:The_Gilman_News/services/stats/articlestorage.dart';

class Globals {
  static bool followed_changed = true;
  static bool clicked = false;
  static int numberofselected = 0;
  static ValueNotifier<Set<String>> followedAuthorNotifier =
      ValueNotifier<Set<String>>({});
  // Create a global notifier that any file can access
  static ValueNotifier<Set<int>> globalReadArticlesNotifier =
      ValueNotifier<Set<int>>({});

  static init() async {
    final Storedata _storedata = Storedata();
    followedAuthorNotifier.value =
        ((await _storedata.followed_author_reader()).toSet()).cast<String>();
  }
}
