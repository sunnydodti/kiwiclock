import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kiwiclock/service/supabase_service.dart';

class PingPage extends StatelessWidget {
  const PingPage({super.key});

  @override
  Widget build(BuildContext context) {
    _pingSupabase();
    return Center(
      child: Scaffold(body: Card(child: Center(child: Text('App online')))),
    );
  }

  void _pingSupabase() async  {
    try {
      if (kDebugMode) debugPrint('pinging supaabase');
      await SupabaseService().ping();
      if (kDebugMode) debugPrint('supaabase pinged');
    } catch (e) {
      if (kDebugMode) debugPrint(e.toString());
    }
  }
}
