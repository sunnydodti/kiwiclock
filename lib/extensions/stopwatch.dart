class StopWatch extends Stopwatch {
  int _starterMilliseconds = 0;

  StopWatch();

  get elapsedDuration {
    return Duration(
        microseconds: elapsedMicroseconds + (_starterMilliseconds * 1000));
  }

  get elapsedMillis {
    return elapsedMilliseconds + _starterMilliseconds;
  }

  set milliseconds(int timeInMilliseconds) {
    _starterMilliseconds = timeInMilliseconds;
  }

  String get timeString {
    var milli = elapsedDuration.inMilliseconds;

    String milliseconds = (milli % 1000).toString().padLeft(3, '0');
    String seconds = ((milli ~/ 1000) % 60).toString().padLeft(2, '0');
    String minutes = ((milli ~/ 1000) ~/ 60).toString().padLeft(2, '0');

    return '$minutes:$seconds:$milliseconds';
  }
}
