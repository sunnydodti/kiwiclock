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
}
