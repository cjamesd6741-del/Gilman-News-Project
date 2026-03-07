import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/cardbuilder.dart';
import '../services/cardclass.dart';
import '../pages/articlesearch.dart';
import '../services/searchclass.dart';

class AllArticlesPage extends StatefulWidget {
  const AllArticlesPage({super.key});
  @override
  State<AllArticlesPage> createState() => _AllArticlesPageState();
}

class _AllArticlesPageState extends State<AllArticlesPage> {
  List<Searchclass> articles = [];
  final _future = Supabase.instance.client
      .from('Articles')
      .select('Author, Article_Title, Date, Article_ID, edition_num');

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 158, 175, 206),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              forceElevated: true,
              shadowColor: Colors.black,
              elevation: 4.0,
              backgroundColor: const Color.fromARGB(255, 34, 72, 92),
              expandedHeight: 180,
              collapsedHeight: 90,
              pinned: true,
              floating: true,
              flexibleSpace: Stack(
                children: [
                  FlexibleSpaceBar(
                    background: Image.asset(
                      'lib/images/IMG_0425.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      width: double.infinity,
                      height: double.infinity,
                      color: innerBoxIsScrolled
                          ? const Color.fromARGB(255, 34, 72, 92)
                          : Colors.transparent,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 100),
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: innerBoxIsScrolled
                                      ? Colors.white
                                      : Color.fromARGB(255, 34, 72, 92),
                                ),

                                child: Text('Gilman News'),
                              ),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 100),
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: innerBoxIsScrolled
                                      ? Colors.white
                                      : Color.fromARGB(255, 34, 72, 92),
                                ),
                                child: Text('All Articles'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(3),
                child: Container(
                  color: const Color.fromARGB(255, 31, 30, 46),
                  height: 3,
                ),
              ),
            ),
          ];
        },
        body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final instruments = snapshot.data!;
            articles = instruments
                .map(
                  (instrument) => Searchclass(
                    searcharticletitle: instrument['Article_Title'],
                    searchauthor: instrument['Author'],
                    searchdate: instrument['Date'],
                    edition_num: instrument['edition_num'],
                  ),
                )
                .toList();

            return ListView.builder(
              itemCount: instruments.length + 1,
              itemBuilder: ((context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: AllArticleSearch(
                              articles: articles,
                            ), //not even remotely confusing lol
                          );
                        },
                        icon: Icon(Icons.search_rounded, color: Colors.black),
                      ),
                    ),
                  );
                } // End of index button\
                final instrument = instruments[index - 1];
                return ListTile(
                  title: CurrentCardbuild(
                    currentcardclass: CurrentCardclass(
                      articleTitle: instrument['Article_Title'],
                      author: instrument['Author'],
                      date: instrument['Date'],
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
