import 'package:hive_flutter/hive_flutter.dart';

class CacheManager {
  CacheManager._internal();
  static final CacheManager _instance = CacheManager._internal();
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
    if (data != null) {
      return data;
    }
    return null;
  }

  void clear(key) {
    box.delete(key);
  }
}
