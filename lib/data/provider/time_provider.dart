import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import 'package:kiwiclock/data/constants.dart';
import 'package:kiwiclock/service/supabase_service.dart';

import '../../extensions/stopwatch.dart';
import '../../models/stopwatch_history.dart';

class TimeProvider extends ChangeNotifier {
  late Box box;
  late SupabaseService _supabaseService;

  late StopWatch _stopwatch;
  bool isStopWatchCompleted = false;
  late StopwatchHistory _stopwatchHistory;
  StopwatchHistory? _completedStopwatchHistory;
  late List<StopwatchHistory> _stopwatchHistories = [];
  bool _isSwHView = false;

  TimeProvider() {
    _stopwatchHistory = StopwatchHistory();
    box = Hive.box(Constants.box);
    _supabaseService = SupabaseService();
    _stopwatch = StopWatch();

    getStopWatchHistories(notify: false);
    // _stopwatch.
  }

  StopWatch get stopWatch => _stopwatch;
  StopwatchHistory? get stopwatchHistory => _completedStopwatchHistory;
  bool get isSwHView => _isSwHView;
  List<StopwatchHistory> get stopwatchHistories => _stopwatchHistories;

  void toggleSwHView() {
    _isSwHView = !_isSwHView;
    notifyListeners();
  }

  void startStopwatch() {
    if (!_stopwatch.isRunning) {
      _completedStopwatchHistory = null;
      _stopwatchHistory.startTime = DateTime.now();
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
      _stopwatchHistory.endTime = DateTime.now();
      _stopwatch.stop();
      _stopwatchHistory.duration = _stopwatch.elapsedDuration;
      _stopwatch.reset();
      notifyListeners();

      _completedStopwatchHistory = _stopwatchHistory;
      _stopwatchHistory = StopwatchHistory();
      _stopwatchHistories.add(_completedStopwatchHistory!);
      _saveStopWatchHistories();
    }
  }

  String getTimeString() {
    var milli = _stopwatch.elapsedDuration.inMilliseconds;

    String milliseconds = (milli % 1000).toString().padLeft(3, '0');
    String seconds = ((milli ~/ 1000) % 60).toString().padLeft(2, '0');
    String minutes = ((milli ~/ 1000) ~/ 60).toString().padLeft(2, '0');

    return '$minutes:$seconds:$milliseconds';
  }

  void getStopWatchHistories({bool notify = true}) {
    List<dynamic> swhs =
        box.get(Constants.stopwatchHistoriesKey, defaultValue: []);
    if (swhs.isNotEmpty) {
      for (var swh in swhs) {
        _stopwatchHistories.add(StopwatchHistory.fromJson(swh));
      }
    }
  }

  void _saveStopWatchHistories() {
    List<Map<dynamic, dynamic>> swhs = [];
    for (var swh in _stopwatchHistories) {
      swhs.add(swh.toJson());
    }
    box.put(Constants.stopwatchHistoriesKey, swhs);
  }

  Future<String> shareCurrentHistory() async {
    if (stopwatchHistory == null) return '';
    if (stopwatchHistory!.id != null) return stopwatchHistory!.id!;

    final result =
        await _supabaseService.saveStopWatchHistory(stopwatchHistory!);
    _completedStopwatchHistory!.id = result[0]['id'];
    _stopwatchHistories.last = _completedStopwatchHistory!;
    _saveStopWatchHistories();
    notifyListeners();
    return stopwatchHistory!.id!;
  }

  Future<String> shareHistory(StopwatchHistory swh) async {
    if (swh.id != null) return swh.id!;

    final result =
        await _supabaseService.saveStopWatchHistory(stopwatchHistory!);
    swh.id = result[0]['id'];
    _stopwatchHistories.firstWhere((h) {
      return h.duration == swh.duration &&
          h.startTime == swh.startTime &&
          h.endTime == swh.endTime;
    }).id = swh.id;
    _saveStopWatchHistories();
    notifyListeners();
    return stopwatchHistory!.id!;
  }

  void deleteStopWatchHistory(StopwatchHistory history) {
    _stopwatchHistories.removeWhere((swh) {
      if (swh.id != null) return swh.id == history.id;
      return swh.duration == history.duration &&
          swh.startTime == history.startTime &&
          swh.endTime == history.endTime;
    });

    _saveStopWatchHistories();
    notifyListeners();
  }
}
