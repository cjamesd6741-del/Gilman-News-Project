import 'package:supabase_flutter/supabase_flutter.dart';

class Getter {
  String author;
  String title;
  Getter({required this.author, required this.title});
  Future fetchArticleJson() async {
    Map info = await Supabase.instance.client
        .from('Articles')
        .select('json_article_file, Extra_Article_Room , Image_urls, Image_label')
        .eq('Author', author)
        .eq('Article_Title', title)
        .single();
    if (info['Image_urls'] != null) {
      Map infowthimage =  info['json_article_file'];
      infowthimage['Image_urls'] = info['Image_urls'];
      if (info['Image_label'] != null) {
        infowthimage['Image_label'] = info['Image_label'];
        info['json_article_file'] = infowthimage;
      }
      info['json_article_file'] = infowthimage; 
      return info['json_article_file'];
    }
    if (info['Extra_Article_Room'] == null) {
      return info['json_article_file'];
    }
    else{
      final extraInfo = info['Extra_Article_Room'];
      final List listextra = extraInfo['body'];
      final List mainlist = info['json_article_file']['body'];
      final combinedList = [...mainlist, ...listextra];
      info['json_article_file']['body'] = combinedList;
      return info['json_article_file'];
    }

  }
}