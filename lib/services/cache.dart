import 'package:hive_flutter/hive_flutter.dart';

class CacheManager {
  CacheManager._privateConstructor();
  static final CacheManager _instance = CacheManager._privateConstructor();
  factory CacheManager() => _instance;
  late Box box;
  Future<void> init() async {
    box = await Hive.openBox('cache');
  }

  Future<void> save(String key, dynamic data) async {
    await box.put(key, data);
  }

  dynamic get(String key) {
    final data = box.get(key);
    return data;
  }

  void clear(String key) {
    box.delete(key);
  }
}
