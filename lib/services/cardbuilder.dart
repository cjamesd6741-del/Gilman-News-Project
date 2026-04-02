import 'package:apitest_2/services/cardclass.dart';
import 'package:flutter/material.dart';
import 'package:apitest_2/services/globals.dart';

class Cardbuild extends StatelessWidget {
  final ArticleWithReadStatus article;
  const Cardbuild({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final isUnread = !article.isRead;
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
        child: InkWell(
          splashColor: Colors.white,
          highlightColor: Colors.blueGrey,
          onTap: () async {
            if (Globals.clicked == false) {
              Globals.clicked = true;
              await Future.delayed(const Duration(milliseconds: 350));
              Navigator.of(context).pushNamed(
                '/loading',
                arguments: {
                  'title': article.article.Article_Title,
                  'author': article.article.author,
                },
              );
            }
            ;
          },
          child: Padding(
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
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CurrentCardbuild extends StatelessWidget {
  final ArticleWithReadStatus article;
  final VoidCallback? onleave;
  final VoidCallback? onReturn;
  const CurrentCardbuild({
    super.key,
    required this.article,
    this.onleave,
    this.onReturn,
  });
  @override
  Widget build(BuildContext context) {
    final isUnread = !article.isRead;

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
      child: SizedBox(
        width: double.infinity,
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
          child: InkWell(
            splashColor: Colors.white,
            highlightColor: Colors.blueGrey,
            onTap: () async {
              if (Globals.clicked == false) {
                Globals.clicked = true;
                onReturn?.call();
                if (article.article.prevauthor == null) {
                  await Future.delayed(const Duration(milliseconds: 350));
                  Navigator.of(context).pushNamed(
                    '/loading',
                    arguments: {
                      'title': article.article.Article_Title,
                      'author': article.article.author,
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
                    },
                  );
                }
              }
            },
            child: Padding(
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
                  const SizedBox(height: 10),
                  Text(
                    article.article.Date,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 11,
                      color: Color.fromARGB(255, 190, 190, 190),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
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
