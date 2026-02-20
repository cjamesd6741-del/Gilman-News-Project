import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:apitest_2/pages/article_page.dart';
import 'package:apitest_2/pages/loading.dart';
import 'package:apitest_2/pages/all_articles.dart';
import 'package:apitest_2/pages/currentarticles.dart';
import 'pages/stats.dart';
import 'pages/routmanager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://obzabvjplufncjyirrhk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9iemFidmpwbHVmbmNqeWlycmhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgzNTI3MzIsImV4cCI6MjA4MzkyODczMn0.TUpNCVq7GqA2lpKjs7r24093jDjD5MUeyK8oQYeDEls',
  );
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) =>  HomePage(),
      // '/current_articles': (context) =>  CurrentArticles(),
      // '/all_articles' : (context) =>  AllArticlesPage(),
      // '/article_page' : (context) =>  Article_Page(),
      // '/loading' : (context) =>  Loading(),
      // '/stats' : (context) =>  Stats(),

    }


  ));
}


