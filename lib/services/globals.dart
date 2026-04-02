import 'package:flutter/material.dart';

class Globals {
  static bool followed_changed = true;
  static bool clicked = false;
  // Create a global notifier that any file can access
  static ValueNotifier<Set<int>> globalReadArticlesNotifier =
      ValueNotifier<Set<int>>({});
}
