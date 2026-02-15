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

}