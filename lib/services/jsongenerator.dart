import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class Getter {
  const Getter();
  Future fetchAuthorJson(String author) async {
    Map info = await Supabase.instance.client
        .from("front_end_author_info")
        .select()
        .eq('Author', author)
        .single();

    print(info);
    return info;
  }

  Future fetchArticleJson(int id) async {
    final info = await Supabase.instance.client.rpc(
      'get_article',
      params: {'target_id': id.toInt()},
    );
    print(info.keys);
    print(info['Extra_Article_Room']);
    return json_formatter(info);
  }

  Map json_formatter(dynamic info) {
    if (info['Image_urls'] != null) {
      // this is a mess I need to clean up soon
      Map infowthimage = info['json_article_file'];
      infowthimage['Image_urls'] = info['Image_urls'];
      if (info['Image_label'] != null) {
        infowthimage['Image_label'] = info['Image_label'];
      }
      info['json_article_file'] = infowthimage;
      if (info['Extra_Article_Room'] == null) {
        info['json_article_file']['id'] = info["Article_ID"];
        return info['json_article_file'];
      } else {
        final extraInfo = info['Extra_Article_Room'];
        final extra_extraInfo = info['Extra_Extra_Article_Room'] ?? {};
        final List listextra_extra = extra_extraInfo['body'] ?? [];
        final List listextra = extraInfo['body'];
        final List mainlist = info['json_article_file']['body'];
        final combinedList = [...mainlist, ...listextra, ...listextra_extra];
        info['json_article_file']['body'] = combinedList;
        info['json_article_file']['id'] = info["Article_ID"];
        return info['json_article_file'];
      }
    }
    if (info['Extra_Article_Room'] == null) {
      info['json_article_file']['id'] = info["Article_ID"];
      return info['json_article_file'];
    } else {
      final extraInfo = info['Extra_Article_Room'];
      final extra_extraInfo = info['Extra_Extra_Article_Room'] ?? {};
      final List listextra_extra = extra_extraInfo['body'] ?? [];
      final List listextra = extraInfo['body'];
      final List mainlist = info['json_article_file']['body'];
      final combinedList = [...mainlist, ...listextra, ...listextra_extra];
      info['json_article_file']['body'] = combinedList;
      info['json_article_file']['id'] = info["Article_ID"];
      return info['json_article_file'];
    }
  }

  Future<Map<dynamic, dynamic>> fetch_article_of_the_day() async {
    print("fetching...");
    final info = await Supabase.instance.client.rpc('get_article_of_the_day');
    try {
      Map article = info as Map<dynamic, dynamic>;
      Map json = json_formatter(article);
      String title = article['Article_Title'] ?? "Gilman Is The Best";
      String author = article['Author'] ?? 'John Doe';
      Map return_object = {'json': json, 'title': title, 'author': author};
      return return_object;
    } catch (_) {
      return Future.error("supabase failed to fetch");
    }
  }
}
