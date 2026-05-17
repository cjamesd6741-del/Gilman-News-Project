import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/jsongenerator.dart';
import 'package:The_Gilman_News/services/globals.dart';
import 'package:supabase/supabase.dart';

class Connectionloading extends StatefulWidget {
  const Connectionloading({super.key});

  @override
  State<Connectionloading> createState() => _Connectionloading();
}

class _Connectionloading extends State<Connectionloading> {
  Map data = {};

  getData(int id) async {
    data = await Supabase.instance.client
        .from('Connections')
        .select('connection_data')
        .eq('id', id)
        .single();
    push();
  }

  void push() {
    Navigator.pushReplacementNamed(
      context,
      '/connection',
      arguments: {'connection_data': data['connection_data']},
    );
  }

  @override
  void initState() {
    super.initState();
    Globals.clicked = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map) {
        data = args;
        getData(data['id'] as int);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: SpinKitFadingCircle(color: Colors.blue, size: 50.0)),
        ],
      ),
    );
  }
}
