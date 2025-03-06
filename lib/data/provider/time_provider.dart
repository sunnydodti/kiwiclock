import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import 'package:kiwiclock/data/constants.dart';

import '../../extensions/stopwatch.dart';

class TimeProvider extends ChangeNotifier {
  late Box box;

  late StopWatch _stopwatch;
  bool isStopWatchCompleted = false;

  TimeProvider() {
    box = Hive.box(Constants.box);
    _stopwatch = StopWatch();
    // _stopwatch.
  }

  StopWatch get stopWatch => _stopwatch;

  void startStopwatch() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      notifyListeners();
    }
  }

  void stopStopWatch() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      notifyListeners();
    }
  }

  String getTimeString() {
    var milli = _stopwatch.elapsedDuration.inMilliseconds;

    String milliseconds = (milli % 1000).toString().padLeft(3, '0');
    String seconds = ((milli ~/ 1000) % 60).toString().padLeft(2, '0');
    String minutes = ((milli ~/ 1000) ~/ 60).toString().padLeft(2, '0');

    return '$minutes:$seconds:$milliseconds';
  }
}
