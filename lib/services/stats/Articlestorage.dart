import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import '/services/stats/storage.dart';

class Storedata { // handles all interactions with files
  String state = "";
  String catstate = "";
  Storage storage = Storage();
  CatStorage catstorage = CatStorage();
  RecentStorage recentstorage = RecentStorage();
  int articlesRead = 0;
  Map data = {};
  Map catdata = {};
  Duration totalduration = Duration.zero;
  Queue<String> past10articles = Queue<String>();

  Future<void> updatearticleread() async {
      state = await storage.filereader();
      if (state == 'didnt work') {
        articlesRead = 0;
        data['articlesRead'] = articlesRead;
      }
      else {
        data = jsonDecode(state);
        articlesRead = data['articlesRead'];
      }
      articlesRead++;
      data['articlesRead'] = articlesRead;
      String enocodeddata = jsonEncode(data);
      await storage.writing(enocodeddata);
  }// add one to articles read count

  Future<void> durationupdate(Duration duration) async {
      state = await storage.filereader();
      if (state == 'didnt work') {
        debugPrint('no file found');
        data["duration"] = Duration.zero.inSeconds;
      }
      else {
        data = jsonDecode(state);
        totalduration = Duration(seconds : data["duration"] ?? 0);
      }
      totalduration = duration + totalduration;
      data['duration'] = totalduration.inSeconds;
      String enocodeddata = jsonEncode(data);
      await storage.writing(enocodeddata);
  }// add one to articles read count

  Future<int> numarticleread() async {
      String state = await storage.filereader();
      if (state == 'didnt work') {
        debugPrint(state);
        return 0; 
      }
      else {
        Map data = jsonDecode(state);
        return data['articlesRead'];
      }
  }// return number of articles read

  Future<Duration> durationreader() async {
      String state = await storage.filereader();
      if (state == 'didnt work') {
        debugPrint(state);
        return Duration.zero;
      }
      else {
        Map data = jsonDecode(state);
        debugPrint(state);
        return Duration(seconds : data['duration']) ;
      }
  }// return total duration

  Future<void> past10update(Queue<String> recents ) async { //Recent articles section
    String state = await recentstorage.filereader();
    if (state == 'didnt work') {
      debugPrint(state);
      past10articles = recents;
      String enocodeddata = jsonEncode(past10articles.toList());
      await recentstorage.writing(enocodeddata);
    }
    else {
      past10articles = Queue.from(jsonDecode(state));
      if (past10articles.length <= 27) {
        past10articles.addAll(recents);
        debugPrint('41');
      }
      else {
        for (int i = 0; i < recents.length; ++i){
          past10articles.removeFirst();
        }
        debugPrint('67');
        past10articles.addAll(recents);
      }
      String enocodeddata = jsonEncode(past10articles.toList());
      await recentstorage.writing(enocodeddata);
    }
    debugPrint(past10articles.length.toString());
  }// return queue of past 10 articles read

  Future<List> past10reader() async {
    String state = await recentstorage.filereader();
    if (state == 'didnt work') {
      debugPrint(state);
      return [];
    }
    else {
      List data = jsonDecode(state);
      debugPrint(data.toString());
      return data;
    }
  }

  Future<void> categorywriter(List category) async {
    String catstate = await catstorage.filereader();
    if (catstate == 'didnt work') {
      debugPrint(catstate);
      for (int i = 0; i < category.length; ++i) 
      {
          catdata[category[i]] = 1;
      }
      debugPrint(catdata.toString());
      String enocodeddata = jsonEncode(catdata);
      await catstorage.writing(enocodeddata);
    }  
    else {   
    catdata = jsonDecode(catstate);
    for (int i = 0; i < category.length; ++i) 
      {
      if (catdata[category[i]] == null) {
        catdata[category[i]] = 1;
      }
      if (catdata[category[i]] != null) {
        catdata[category[i]] = catdata[category[i]] + 1;
      }
    }  
    debugPrint(catdata.toString());
    String enocodeddata = jsonEncode(catdata);
    await catstorage.writing(enocodeddata);   
    }
  }// write categories from article to file
  
  Future<Map> categoryreader() async {
    String state = await catstorage.filereader();
    if (state == 'didnt work') {
      debugPrint(state);
      return {};
    }
    else {
      Map data = jsonDecode(state);
      debugPrint(data.toString());
      return data;
    }
  }

}