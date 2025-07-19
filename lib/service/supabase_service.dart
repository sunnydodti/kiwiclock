import 'dart:async';

import 'package:kiwiclock/models/stopwatch_event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/constants.dart';

class SupabaseService {
  SupabaseService();

  Future saveStopWatchEvent(StopwatchEvent swe) async {
    return await Supabase.instance.client
        .from(Constants.stopwatchTable)
        .insert(swe.toJson())
        .select('*');
  }

  Future getStopWatchEventById(String id) async {
    return Supabase.instance.client
        .from(Constants.stopwatchTable)
        .select('*')
        .eq('id', id)
        .maybeSingle();
  }

  Future updateStopWatchEventById(StopwatchEvent swe) async {
    if (swe.id == null) return;
    return Supabase.instance.client
        .from(Constants.stopwatchTable)
        .update(swe.toJson())
        .eq('id', swe.id!);
  }

  StreamSubscription<SupabaseStreamEvent> streamStopWatchEventById(
    String id,
    Function(List<Map<String, dynamic>>) onDataReceived,
  ) {
    return Supabase.instance.client
        .from('stopwatch')
        .stream(primaryKey: [id])
        .eq('id', id)
        .listen(onDataReceived);
  }

  ping() async {
    final data = await Supabase.instance.client.from(Constants.logsTable).insert({'type': 1});
    print(data);
  }
}
