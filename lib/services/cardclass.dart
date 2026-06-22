class ArticleWithReadStatus {
  final Article article;
  final bool isRead;
  ArticleWithReadStatus({required this.article, required this.isRead});
}

class Article {
  final String author;
  final String Article_Title;
  final String Date;
  final double edition_num;
  final int Article_ID;
  final String? prevtitle;
  final String? prevauthor;
  final int? previd;
  final List<String>? tags;

  final String all;
  Article({
    required this.author,
    required this.Article_ID,
    required this.Date,
    required this.Article_Title,
    required this.edition_num, //completely vestigial, might remove
    this.prevauthor,
    this.prevtitle,
    this.previd,
    this.tags,
  }) : all = normalize("$Article_Title $author $Date");
}

String normalize(String s) {
  return s
      .toLowerCase()
      .replaceAll('’', "'")
      .replaceAll('‘', "'")
      .replaceAll('“', '"')
      .replaceAll('”', '"')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}
