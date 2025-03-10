import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import 'package:kiwiclock/data/constants.dart';
import 'package:kiwiclock/service/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../extensions/stopwatch.dart';
import '../../models/stopwatch_event.dart';

class TimeProvider extends ChangeNotifier {
  late Box box;
  late SupabaseService _supabaseService;

  late StopWatch _stopwatch;
  late StopWatch _pauseStopWatch;
  StopwatchEvent? _swe;
  List<StopwatchEvent> _stopwatchEvents = [];
  bool _isSweView = false;

  TimeProvider() {
    box = Hive.box(Constants.box);
    _supabaseService = SupabaseService();

    _stopwatch = StopWatch();
    _pauseStopWatch = StopWatch();
    // _swe = StopwatchEvent();

    _getStopWatchEvents(notify: false);
    _getCurrentStopWatchEvent(notify: false);
    // _stopwatch.
  }

  StopWatch get stopWatch => _stopwatch;
  StopwatchEvent? get stopwatchEvent => _swe;
  bool get isSweView => _isSweView;
  List<StopwatchEvent> get stopwatchEvents => _stopwatchEvents;

  void toggleSweView() {
    _isSweView = !_isSweView;
    notifyListeners();
  }

  void startStopwatch() {
    if (!_stopwatch.isRunning) {
      _swe = null;
      _swe = StopwatchEvent();
      _stopwatch.start();
      _swe!.startTime = DateTime.now().toUtc();
      if (_pauseStopWatch.isRunning) {
        _pauseStopWatch.stop();
        _swe!.pauseDuration += _pauseStopWatch.elapsedDuration;
        _pauseStopWatch.reset();
      }
      notifyListeners();
      _stopwatchEvents.add(_swe!);

      _updateCurrentSwe();
      _saveCurrentStopWatchEvent();
    }
  }

  void pauseStopWatch() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _pauseStopWatch.start();
      _swe!.isPaused = true;
      notifyListeners();

      _saveCurrentStopWatchEvent();
      _saveStopWatchEvents();
      _updateCurrentSwe();
    }
  }

  void resumeStopWatch() {
    if (_pauseStopWatch.isRunning) {
      _pauseStopWatch.stop();
      _stopwatch.start();
      _swe!.pauseDuration += _pauseStopWatch.elapsedDuration;
      _pauseStopWatch.reset();
      _swe!.isPaused = false;
      notifyListeners();

      _saveCurrentStopWatchEvent();
      _saveStopWatchEvents();
      _updateCurrentSwe();
    }
  }

  void stopStopWatch() {
    if (_stopwatch.elapsedMilliseconds > 0) {
      _swe!.endTime = DateTime.now().toUtc();

      _stopwatch.stop();
      _pauseStopWatch.reset();

      _swe!.duration = _stopwatch.elapsedDuration;
      _stopwatch.reset();
      notifyListeners();

      _saveStopWatchEvents();
      _updateCurrentSwe();
    }
  }

  String get timeString => _stopwatch.timeString;

  void _getStopWatchEvents({bool notify = true}) {
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

  void _saveCurrentStopWatchEvent() {
    if (_swe == null) return;
    box.put(Constants.currentStopwatchEventKey, _swe!.toJson());
  }

  void _getCurrentStopWatchEvent({bool notify = true}) {
    StopwatchEvent? swe = box.get(Constants.currentStopwatchEventKey);
    if (swe != null) _swe = swe;
    if (notify) notifyListeners();
  }

  Future<String> shareCurrentSwe() async {
    if (stopwatchEvent == null) return '';
    if (stopwatchEvent!.id != null) return stopwatchEvent!.id!;

    final result = await _supabaseService.saveStopWatchEvent(stopwatchEvent!);
    _swe!.id = result[0]['id'];
    _stopwatchEvents.last = _swe!;
    _saveStopWatchEvents();
    notifyListeners();
    return stopwatchEvent!.id!;
  }

  Future<String> shareSwe(StopwatchEvent swe) async {
    if (swe.id != null) return swe.id!;

    final result = await _supabaseService.saveStopWatchEvent(stopwatchEvent!);
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

  void _updateCurrentSwe() {
    if (_swe == null || _swe!.id == null) return;
    _supabaseService.updateStopWatchEventById(_swe!);
  }
}
