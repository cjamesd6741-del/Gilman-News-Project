import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class Storage { // writes and reads files
  Future<String> get paths async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File> get localfile async {
    final path = await paths;
    return File('$path/statistics.txt');
  }
  Future<String> filereader() async {
    try {
      final file =  await localfile;
      return await file.readAsString();
    }
    catch (e) {
      return 'didnt work';
    }
  }
  Future<File> writing(String material) async {
    final file = await localfile;
    return file.writeAsString(material);
  }

  Future<void> delete() async {
    final file = await localfile;
    try {await file.delete();}
    catch(e) {
      debugPrint('file never existed');
    }
  }

}

class CatStorage { // writes and reads files for categories
  Future<String> get paths async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File> get localfile async {
    final path = await paths;
    return File('$path/preferences.txt');
  }
  Future<String> filereader() async {
    try {
      final file =  await localfile;
      return await file.readAsString();
    }
    catch (e) {
      return 'didnt work';
    }
  }

  Future<File> writing(String material) async {
    final file = await localfile;
    return file.writeAsString(material);
  }

  Future<void> delete() async {
    final file = await localfile;
    try {await file.delete();}
    catch(e) {
      debugPrint('file never existed');
    }
  }


}

class RecentStorage { // writes and reads files for categories
  Future<String> get paths async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File> get localfile async {
    final path = await paths;
    return File('$path/recents.txt');
  }
  Future<String> filereader() async {
    try {
      final file =  await localfile;
      return await file.readAsString();
    }
    catch (e) {
      return 'didnt work';
    }
  }

  Future<File> writing(String material) async {
    final file = await localfile;
    return file.writeAsString(material);
  }

  Future<void> delete() async {
    final file = await localfile;
    try {await file.delete();}
    catch(e) {
      debugPrint('file never existed');
    }
  }


}

class AuthorStorage { // writes and reads files for categories
  Future<String> get paths async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File> get localfile async {
    final path = await paths;
    return File('$path/authorpref.txt');
  }
  Future<String> filereader() async {
    try {
      final file =  await localfile;
      return await file.readAsString();
    }
    catch (e) {
      return 'didnt work';
    }
  }

  Future<File> writing(String material) async {
    final file = await localfile;
    return file.writeAsString(material);
  }

  Future<void> delete() async {
    final file = await localfile;
    try {await file.delete();}
    catch(e) {
      debugPrint('file never existed');
    }
  }


}


class ClearData {
  Storage storage = Storage();
  CatStorage catStorage = CatStorage();
  RecentStorage recentStorage = RecentStorage();
  AuthorStorage authorStorage = AuthorStorage();

  Future<void> clear () async {
    storage.delete();
    catStorage.delete();
    recentStorage.delete();
    authorStorage.delete();
  }
}