import 'package:The_Gilman_News/pages/splash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/routmanager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:The_Gilman_News/services/cache.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

// TODO : Explain Why
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('cache');
  await CacheManager().init();

  await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  await OneSignal.initialize("bf389e28-ff57-44a9-b92a-fa781eeab0e0");
  await OneSignal.Location.setShared(false); // stops geotracking by onesignal
  await OneSignal.Notifications.requestPermission(false);

  await Supabase.initialize(
    url: 'https://obzabvjplufncjyirrhk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9iemFidmpwbHVmbmNqeWlycmhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgzNTI3MzIsImV4cCI6MjA4MzkyODczMn0.TUpNCVq7GqA2lpKjs7r24093jDjD5MUeyK8oQYeDEls',
  );

  runApp(
    MaterialApp(initialRoute: '/', routes: {'/': (context) => SplashScreen()}),
  );
}
