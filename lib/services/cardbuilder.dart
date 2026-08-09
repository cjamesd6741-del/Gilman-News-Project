import 'dart:ffi';

import 'package:The_Gilman_News/services/cardclass.dart';
import 'package:flutter/material.dart';
import 'package:The_Gilman_News/services/globals.dart';
import 'package:google_fonts/google_fonts.dart';

class Recent_Article_Cardbuild extends StatelessWidget {
  final ArticleWithReadStatus article;
  const Recent_Article_Cardbuild({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final isUnread = !article.isRead;
    List<String> tags = article.article.tags ?? [];
    bool show_tags = tags.isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: isUnread
            ? [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: .6),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: Card(
        elevation: 10,
        shadowColor: const Color.fromARGB(255, 116, 127, 149),
        color: const Color.fromARGB(255, 46, 48, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: Color.fromARGB(255, 80, 83, 87),
            width: 4,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    article.article.Article_Title,
                    style: const TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    article.article.author,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                      color: Color.fromARGB(255, 220, 220, 220),
                    ),
                  ),
                  if (show_tags) const SizedBox(height: 10),
                  if (show_tags)
                    Wrap(
                      // note: didn't just use article.article.tags because map doesnt work with nullable variables
                      children: tags
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: BorderSide(
                                    color: Colors.blueGrey,
                                    width: 2,
                                  ),
                                ),
                                color: const Color.fromARGB(255, 27, 81, 126),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5.0,
                                    horizontal: 7,
                                  ),
                                  child: Text(
                                    e,
                                    style: GoogleFonts.lora(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: const Color.fromARGB(92, 255, 255, 255),
                  highlightColor: const Color.fromARGB(125, 108, 137, 152),
                  onTap: () async {
                    if (Globals.clicked == false) {
                      try {
                        FocusManager.instance.primaryFocus
                            ?.unfocus(); //unfocuses keyboard to prevent bug where app autocorrects causing mounting error.
                      } catch (_) {}
                      await Future.delayed(const Duration(milliseconds: 150));
                      Globals.clicked = true;
                      if (!context.mounted) return;

                      Navigator.of(context).pushNamed(
                        '/loading',
                        arguments: {
                          'title': article.article.Article_Title,
                          'author': article.article.author,
                          'ID': article.article.Article_ID,
                        },
                      );
                    }
                    ;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Other_Instances_Cardbuild extends StatelessWidget {
  final ArticleWithReadStatus article;
  final VoidCallback? onleave;
  final VoidCallback? onReturn;
  final double? width;
  final double? height;

  const Other_Instances_Cardbuild({
    super.key,
    required this.article,
    this.onleave,
    this.onReturn,
    this.width = null,
    this.height = null,
  });
  @override
  Widget build(BuildContext context) {
    final isUnread = !article.isRead;
    List<String> tags = article.article.tags ?? [];
    bool show_tags = tags.isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: isUnread
            ? [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: .85),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: Card(
        elevation: 10,
        shadowColor: const Color.fromARGB(255, 116, 127, 149),
        color: const Color.fromARGB(255, 46, 48, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: const Color.fromARGB(255, 80, 83, 87),
            width: isUnread ? 5 : 4,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            SizedBox(
              width: width,
              height: height,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 0, 0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: height ?? double.infinity,
                      maxWidth: width ?? double.infinity,
                    ),
                    child: MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaler: MediaQuery.of(
                          context,
                        ).textScaler.clamp(maxScaleFactor: 1.2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            article.article.Article_Title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            article.article.author,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 18,
                              color: Color.fromARGB(255, 220, 220, 220),
                            ),
                          ),
                          if (show_tags)
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: SizedBox(
                                width: width,
                                child: Wrap(
                                  // note: didn't just use article.article.tags because map doesnt work with nullable variables
                                  children: tags
                                      .map(
                                        (e) => Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            0,
                                            0,
                                            10,
                                            0,
                                          ),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              side: BorderSide(
                                                color: Colors.blueGrey,
                                                width: 2,
                                              ),
                                            ),
                                            color: const Color.fromARGB(
                                              255,
                                              27,
                                              81,
                                              126,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 5.0,
                                                    horizontal: 7,
                                                  ),
                                              child: Text(
                                                e,
                                                style: GoogleFonts.lora(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          Text(
                            article.article.Date,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 18,
                              color: Color.fromARGB(255, 190, 190, 190),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: const Color.fromARGB(137, 255, 255, 255),
                  highlightColor: const Color.fromARGB(138, 96, 125, 139),
                  onTap: () async {
                    if (Globals.clicked == false) {
                      Globals.clicked = true;
                      onleave?.call();
                      onReturn?.call();
                      if (article.article.prevauthor == null) {
                        await Future.delayed(const Duration(milliseconds: 350));
                        if (!context.mounted) return;
                        Navigator.of(context).pushNamed(
                          '/loading',
                          arguments: {
                            'title': article.article.Article_Title,
                            'author': article.article.author,
                            'ID': article.article.Article_ID,
                          },
                        );
                      } else {
                        await Future.delayed(const Duration(milliseconds: 350));
                        Navigator.pushReplacementNamed(
                          context,
                          '/loading',
                          arguments: {
                            'title': article.article.Article_Title,
                            'author': article.article.author,
                            'recommended': true,
                            'prevauthor': article.article.prevauthor,
                            'prevtitle': article.article.prevtitle,
                            'prevID': article.article.previd,
                            'ID': article.article.Article_ID,
                          },
                        );
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FollowCardbuild extends StatelessWidget {
  final ArticleWithReadStatus article;
  const FollowCardbuild({super.key, required this.article});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: const Color.fromARGB(255, 116, 127, 149),
      color: const Color.fromARGB(255, 46, 48, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: Color.fromARGB(255, 80, 83, 87),
          width: 4,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        splashColor: Colors.white,
        highlightColor: Colors.blueGrey,
        onTap: () async {
          await Future.delayed(const Duration(milliseconds: 350));
          Navigator.of(context).pushNamed(
            '/loading',
            arguments: {
              'title': article.article.Article_Title,
              'author': article.article.author,
              'ID': article.article.Article_ID,
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                article.article.Article_Title,
                style: const TextStyle(
                  fontSize: 25,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                article.article.author,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                  color: Color.fromARGB(255, 220, 220, 220),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                article.article.Date,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                  color: Color.fromARGB(255, 190, 190, 190),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
