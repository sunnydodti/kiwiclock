import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import 'package:kiwiclock/data/constants.dart';
import 'package:kiwiclock/service/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../extensions/stopwatch.dart';
import '../../models/stopwatch_history.dart';

class TimeProvider extends ChangeNotifier {
  late Box box;
  late SupabaseService _supabaseService;

  late StopWatch _stopwatch;
  bool isStopWatchCompleted = false;
  late StopwatchEvent _stopwatchEvent;
  StopwatchEvent? _completedStopwatchEvent;
  late List<StopwatchEvent> _stopwatchEvents = [];
  bool _isSweView = false;

  TimeProvider() {
    _stopwatchEvent = StopwatchEvent();
    box = Hive.box(Constants.box);
    _supabaseService = SupabaseService();
    _stopwatch = StopWatch();

    getStopWatchEvents(notify: false);
    // _stopwatch.
  }

  StopWatch get stopWatch => _stopwatch;
  StopwatchEvent? get stopwatchEvent => _completedStopwatchEvent;
  bool get isSweView => _isSweView;
  List<StopwatchEvent> get stopwatchEvents => _stopwatchEvents;

  void toggleSweView() {
    _isSweView = !_isSweView;
    notifyListeners();
  }

  void startStopwatch() {
    if (!_stopwatch.isRunning) {
      _completedStopwatchEvent = null;
      _stopwatchEvent.startTime = DateTime.now();
      _stopwatch.start();
      notifyListeners();
    }
  }

  void pauseStopWatch() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      notifyListeners();
    }
  }

  void stopStopWatch() {
    if (_stopwatch.elapsedMilliseconds > 0) {
      _stopwatchEvent.endTime = DateTime.now();
      _stopwatch.stop();
      _stopwatchEvent.duration = _stopwatch.elapsedDuration;
      _stopwatch.reset();
      notifyListeners();

      _completedStopwatchEvent = _stopwatchEvent;
      _stopwatchEvent = StopwatchEvent();
      _stopwatchEvents.add(_completedStopwatchEvent!);
      _saveStopWatchEvents();
    }
  }

  String getTimeString() {
    var milli = _stopwatch.elapsedDuration.inMilliseconds;

    String milliseconds = (milli % 1000).toString().padLeft(3, '0');
    String seconds = ((milli ~/ 1000) % 60).toString().padLeft(2, '0');
    String minutes = ((milli ~/ 1000) ~/ 60).toString().padLeft(2, '0');

    return '$minutes:$seconds:$milliseconds';
  }

  void getStopWatchEvents({bool notify = true}) {
    List<dynamic> swes =
        box.get(Constants.stopwatchEventsKey, defaultValue: []);
    if (swes.isNotEmpty) {
      for (var swe in swes) {
        _stopwatchEvents.add(StopwatchEvent.fromJson(swe));
      }
    }
  }

  void _saveStopWatchEvents() {
    List<Map<dynamic, dynamic>> swes = [];
    for (var swe in _stopwatchEvents) {
      swes.add(swe.toJson());
    }
    box.put(Constants.stopwatchEventsKey, swes);
  }

  Future<String> shareCurrentSwe() async {
    if (stopwatchEvent == null) return '';
    if (stopwatchEvent!.id != null) return stopwatchEvent!.id!;

    final result =
        await _supabaseService.saveStopWatchEvent(stopwatchEvent!);
    _completedStopwatchEvent!.id = result[0]['id'];
    _stopwatchEvents.last = _completedStopwatchEvent!;
    _saveStopWatchEvents();
    notifyListeners();
    return stopwatchEvent!.id!;
  }

  Future<String> shareSwe(StopwatchEvent swe) async {
    if (swe.id != null) return swe.id!;

    final result =
        await _supabaseService.saveStopWatchEvent(stopwatchEvent!);
    swe.id = result[0]['id'];
    _stopwatchEvents.firstWhere((h) {
      return h.duration == swe.duration &&
          h.startTime == swe.startTime &&
          h.endTime == swe.endTime;
    }).id = swe.id;
    _saveStopWatchEvents();
    notifyListeners();
    return stopwatchEvent!.id!;
  }

  void deleteStopWatchEvent(StopwatchEvent event) {
    _stopwatchEvents.removeWhere((swe) {
      if (swe.id != null) return swe.id == event.id;
      return swe.duration == event.duration &&
          swe.startTime == event.startTime &&
          swe.endTime == event.endTime;
    });

    _saveStopWatchEvents();
    notifyListeners();
  }

  Future<StopwatchEvent?> getSweById(String id) async {
    final result = await _supabaseService.getStopWatchEventById(id);

    if (result.isEmpty) return null;
    return StopwatchEvent.fromJson(result);
  }

  StreamSubscription<SupabaseStreamEvent> streamStopWatchEventById(
    String id,
    Function(List<Map<String, dynamic>>) onDataReceived,
  ) {
    return _supabaseService.streamStopWatchEventById(id, onDataReceived);
  }
}
