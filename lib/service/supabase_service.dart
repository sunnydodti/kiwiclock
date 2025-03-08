import 'dart:async';

import 'package:kiwiclock/models/stopwatch_history.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/constants.dart';

class SupabaseService {
  SupabaseService();

  Future saveStopWatchHistory(StopwatchHistory swh) async {
    return await Supabase.instance.client
        .from(Constants.stopwatchTable)
        .insert(swh.toJson())
        .select('*');
  }

  Future getStopWatchHistory(String id) async {
    return Supabase.instance.client
        .from(Constants.stopwatchTable)
        .select('*')
        .eq('id', id)
        .maybeSingle();
  }

  StreamSubscription<SupabaseStreamEvent> streamStopWatchHistoryById(
    String id,
    Function(List<Map<String, dynamic>>) onDataReceived,
  ) {
    return Supabase.instance.client
        .from('stopwatch')
        .stream(primaryKey: [id])
        .eq('id', id)
        .listen(onDataReceived);
  }
}
