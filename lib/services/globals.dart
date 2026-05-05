import 'package:flutter/material.dart';

class Globals {
  static bool followed_changed = true;
  static bool clicked = false;
  static int numberofselected = 0;
  // Create a global notifier that any file can access
  static ValueNotifier<Set<int>> globalReadArticlesNotifier =
      ValueNotifier<Set<int>>({});
}
