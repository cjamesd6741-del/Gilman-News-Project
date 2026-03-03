class Cardclass {
  String articleTitle;
  String author;
  Cardclass({required this.articleTitle, required this.author});
}

class CurrentCardclass {
  String articleTitle;
  String author;
  String date;
  CurrentCardclass({
    required this.articleTitle,
    required this.author,
    required this.date,
  });
}

class FollowCardclass {
  String articleTitle;
  String author;
  String date;
  double edition_num;
  FollowCardclass({
    required this.articleTitle,
    required this.author,
    required this.date,
    required this.edition_num,
  });
}
