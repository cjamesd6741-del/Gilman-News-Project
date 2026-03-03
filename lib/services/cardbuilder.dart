import 'package:apitest_2/services/cardclass.dart';
import 'package:flutter/material.dart';

class Cardbuild extends StatelessWidget {
  final Cardclass cardclass;
  const Cardbuild({super.key, required this.cardclass});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 46, 48, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: Color.fromARGB(255, 204, 214, 219),
          width: 5,
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
              'title': cardclass.articleTitle,
              'author': cardclass.author,
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
                cardclass.articleTitle,
                style: const TextStyle(
                  fontSize: 25,
                  color: Color.fromARGB(255, 211, 211, 211),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                cardclass.author,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                  color: Color.fromARGB(255, 211, 211, 211),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class CurrentCardbuild extends StatelessWidget {
  final CurrentCardclass currentcardclass;
  const CurrentCardbuild({super.key, required this.currentcardclass});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 46, 48, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: Color.fromARGB(255, 204, 214, 219),
          width: 5,
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
              'title': currentcardclass.articleTitle,
              'author': currentcardclass.author,
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
                currentcardclass.articleTitle,
                style: const TextStyle(
                  fontSize: 25,
                  color: Color.fromARGB(255, 211, 211, 211),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                currentcardclass.author,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                  color: Color.fromARGB(255, 211, 211, 211),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                currentcardclass.date,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 10,
                  color: Color.fromARGB(255, 211, 211, 211),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class FollowCardbuild extends StatelessWidget {
  final FollowCardclass followcardclass;
  const FollowCardbuild({super.key, required this.followcardclass});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 46, 48, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: Color.fromARGB(255, 204, 214, 219),
          width: 5,
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
              'title': followcardclass.articleTitle,
              'author': followcardclass.author,
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
                followcardclass.articleTitle,
                style: const TextStyle(
                  fontSize: 25,
                  color: Color.fromARGB(255, 211, 211, 211),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                followcardclass.author,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                  color: Color.fromARGB(255, 211, 211, 211),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                followcardclass.date,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                  color: Color.fromARGB(255, 211, 211, 211),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
