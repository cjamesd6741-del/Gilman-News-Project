import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/cardbuilder.dart';
import '../../services/cardclass.dart';
import 'package:apitest_2/services/cache.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:apitest_2/games/game_components/connectioncomponents/connection_selector.dart';

class Connectionsselector extends StatefulWidget {
  const Connectionsselector({super.key});
  @override
  State<Connectionsselector> createState() => _Connectionsselector();
}

class _Connectionsselector extends State<Connectionsselector> {
  CacheManager cacheManager = CacheManager();
  bool _isRouteVisible = false; // is on current tab?
  bool _isTabVisible = false; // is on current screen?
  int vnum = 0;
  late Future _future;

  @override
  void initState() {
    vnum = cacheManager.get("connection_version") ?? 0;
    _future = datagenerator();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<List> datagenerator() async {
    var online_version_number = await Supabase.instance.client
        .from('Version_Numbers')
        .select('Table_Name, Version')
        .eq('Table_Name', 'Connections')
        .single();
    if (online_version_number['Version'] != vnum) {
      return getdata(online_version_number['Version']);
    }
    return Future.value(cacheManager.get('connection_data'));
  }

  Future<List> getdata(int vnum) async {
    var data = await Supabase.instance.client
        .from('Connections')
        .select('id, Date');
    print(data);
    cacheManager.save('connection_version', vnum);
    cacheManager.save('connection_data', data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 158, 175, 206),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              // top bar
              forceElevated: true,
              shadowColor: Colors.black,
              elevation: 4.0,
              backgroundColor: const Color.fromARGB(255, 140, 139, 139),
              expandedHeight: MediaQuery.of(context).size.height / 8,
              collapsedHeight: max(80, MediaQuery.of(context).size.height / 12),
              pinned: true,
              floating: true,
              flexibleSpace: Stack(
                fit: StackFit.expand,
                children: [
                  Align(
                    // stacked widgets that become transparent to let widgets below them show when inner box is not scrolled
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
                                style: GoogleFonts.libreCaslonText(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: innerBoxIsScrolled
                                      ? Colors.white
                                      : Color.fromARGB(255, 26, 56, 72),
                                ),

                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text('Gilman Connections'),
                                ),
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
            if (!snapshot.hasData || snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitCubeGrid(size: 50, color: Colors.blueAccent),
                  ],
                ),
              );
            } else {
              var data = snapshot.data as List;
              print(data);
              List<ConnectionSelector> card_data = data
                  .map((e) => ConnectionSelector(date: e["Date"], id: e["id"]))
                  .toList();
              return ListView.builder(
                itemCount: card_data.length,
                itemBuilder: (context, index) {
                  return ConnectionSelectorCard(
                    connectioninfo: card_data[index],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
