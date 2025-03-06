import 'package:flutter/foundation.dart';

class TimeProvider extends ChangeNotifier {
  late Stopwatch _stopwatch;
  TimeProvider() {
    _stopwatch = Stopwatch();
  }

  Stopwatch get stopwatch => _stopwatch;

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
    var milli = _stopwatch.elapsed.inMilliseconds;

    String milliseconds = (milli % 1000).toString().padLeft(3, '0');
    String seconds = ((milli ~/ 1000) % 60).toString().padLeft(2, '0');
    String minutes = ((milli ~/ 1000) ~/ 60).toString().padLeft(2, '0');

    return '$minutes:$seconds:$milliseconds';
  }
}
