import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/cardbuilder.dart';
import '../services/cardclass.dart';

class CurrentArticles extends StatefulWidget {
  const CurrentArticles({super.key});
  @override
  State<CurrentArticles> createState() => _CurrentArticlesState();
}

class _CurrentArticlesState extends State<CurrentArticles> {
  final currentarticledata = Supabase.instance.client
      .from('Current_Articles')
      .select('Author, Article_Title, Date, Article_ID');
  
  @override
  initState() {
      super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers : false,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [SliverAppBar(
          backgroundColor: const Color.fromARGB(255, 34, 72, 92),
          expandedHeight: 180,
          collapsedHeight: 80,
          pinned: true,
          flexibleSpace: Stack(
            fit: StackFit.expand,
            children: [
        Image.asset(
          'lib/images/gilmanschool2.png',
          fit: BoxFit.cover,
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
              children: const [
                Text(
                  'Gilman News',
                  style: TextStyle(
                    fontSize: 26, 
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Current Articles',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    ],
  ),
),

        ];
        },
        body: FutureBuilder(
              future: currentarticledata,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final instruments = snapshot.data!;
                return ListView.builder(
                  itemCount: instruments.length + 1, 
                  itemBuilder: ((context, index) {
                    if (index == instruments.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/all_articles');
                                  },
                                  child: const Text('View All Articles'),
                                ),
                              ),
                            );
                          }// End of index button\
                    final instrument = instruments[index];
                    return ListTile(
                      title: Cardbuild(cardclass: Cardclass(articleTitle: instrument['Article_Title'], author: instrument['Author']),
                    ));
                  }// itemBuilder function
                  ) //itembuilder parenthesis,
                );
              },
            ),
      ),
    );
  }
}