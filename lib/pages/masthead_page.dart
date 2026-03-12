import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:apitest_2/services/cache.dart';
import 'package:apitest_2/services/masthead_year_selector.dart';

class MastHead_Page extends StatefulWidget {
  const MastHead_Page({super.key});

  @override
  State<MastHead_Page> createState() => _MastHead_PageState();
}

class _MastHead_PageState extends State<MastHead_Page> {
  late Future<List> data = Future.value([]);
  late int year = 0;
  double maxyear = 0;
  int version_number = CacheManager().get("masthead_version_number") ?? 0;
  CacheManager cacheManager = CacheManager();

  Future<void> datagenerator() async {
    var online_version_number = await Supabase.instance.client
        .from('Version_Numbers')
        .select('Table_Name, Version')
        .eq('Table_Name,', 'Mastheads')
        .single();
    if (online_version_number['Version'] != version_number) {
      setState(() {
        data = getdata(online_version_number['Version']);
      });
    } else {
      debugPrint('local_call');
      setState(() {
        year = cacheManager.get("masthead_year") ?? 0;
        maxyear = year.toDouble();
        data = Future.value(cacheManager.get("MastHeads"));
      });
    }
  }

  Future<List> getdata(int vnum) async {
    debugPrint("supabase call");
    var futures = await Future.wait<dynamic>([
      Supabase.instance.client
          .from('Mastheads')
          .select('year')
          .order('year', ascending: false)
          .limit(1)
          .single(),
      Supabase.instance.client.from('Mastheads').select(),
    ]);
    final year_data = futures[0];
    final onlinedata = futures[1];
    cacheManager.save('masthead_version_number', vnum);
    cacheManager.save('MastHeads', onlinedata);
    cacheManager.save('masthead_year', year_data['year']);
    year = year_data['year'];
    maxyear = year.toDouble();
    return onlinedata;
  }

  @override
  void initState() {
    super.initState();
    datagenerator();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 215, 215, 215),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              forceElevated: true,
              shadowColor: Colors.black,
              elevation: 4.0,
              backgroundColor: const Color.fromARGB(255, 34, 72, 92),
              expandedHeight: 180,
              collapsedHeight: 80,
              pinned: true,
              flexibleSpace: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('lib/images/Masthead.jpg', fit: BoxFit.cover),
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
                          child: Center(
                            child: Text(
                              'Masthead',
                              style: GoogleFonts.lora(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 75, 141),
                              ),
                            ),
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
        body: InteractiveViewer(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(26, 0, 26, 0),
            child: FutureBuilder(
              future: data,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SpinKitChasingDots(
                    size: 100,
                    color: const Color.fromARGB(255, 22, 21, 88),
                  );
                }
                ;
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                ;
                final useddata = snapshot.data;
                if (useddata == null) {
                  return SpinKitChasingDots(
                    size: 100,
                    color: const Color.fromARGB(255, 22, 21, 88),
                  );
                }
                debugPrint('67');
                Map<dynamic, dynamic>? currentdata;
                try {
                  currentdata = useddata.firstWhere(
                    (map) => map['year'] == year,
                  );
                } catch (e) {
                  print(e.toString());
                  currentdata = null;
                }
                late final staff;
                final int stafflength;
                if (currentdata != null) {
                  staff = currentdata["masthead_data"]?["staff"] ?? [];
                  staff.sort(
                    (a, b) => (a['rank'] as int).compareTo(b['rank'] as int),
                  );
                  stafflength = staff.length + 1;
                } else {
                  staff = [];
                  stafflength = 2;
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: stafflength,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            if (maxyear == 0) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return YearSelector(
                              year: year.toDouble(),
                              firstyear: maxyear,
                              changeyear: (double value) {
                                setState(() {
                                  year = value.toInt();
                                });
                              },
                            );
                          }
                          if (staff.isEmpty) {
                            return Text("No data");
                          }
                          final person = staff[index - 1];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 160,
                                  child: Text(
                                    person['role'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(child: Text(person['name'])),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
