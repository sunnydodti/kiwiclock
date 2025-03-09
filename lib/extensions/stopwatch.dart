class StopWatch extends Stopwatch {
  int _starterMilliseconds = 0;

  StopWatch();

  Duration get elapsedDuration {
    return Duration(
        microseconds: elapsedMicroseconds + (_starterMilliseconds * 1000));
  }

  int get elapsedMillis {
    return elapsedMilliseconds + _starterMilliseconds;
  }

  set milliseconds(int timeInMilliseconds) {
    _starterMilliseconds = timeInMilliseconds;
  }

  String get timeString {
    var milli = elapsedDuration.inMilliseconds;
    DateTime now = DateTime.now().toUtc();
    now.add(Duration(milliseconds: milli));

    int centuries = (milli ~/ (3153600000000));
    int decades = ((milli ~/ (315360000000)) % 10);
    int years = ((milli ~/ (31536000000)) % 10);
    int months = ((milli ~/ (2592000000)) % 12);
    int weeks = ((milli ~/ (604800000)) % 4);
    int days = ((milli ~/ (86400000)) % 7);
    int hours = ((milli ~/ (3600000)) % 24);
    int minutes = ((milli ~/ (60000)) % 60);
    int seconds = ((milli ~/ 1000) % 60);
    int milliseconds = (milli % 1000);

    String result = '';

    if (centuries > 0) result += '${centuries}C ';
    if (decades > 0) result += '${decades}D ';
    if (years > 0) result += '${years}Y ';
    if (months > 0) result += '${months}M ';
    if (weeks > 0) result += '${weeks}W ';
    if (days > 0) result += '${days}d ';
    if (hours > 0) result += '${hours}h ';
    if (minutes > 0) result += '${minutes}m ';
    result += '$seconds.${milliseconds.toString().padLeft(3, '0')}';
    return result;
  }
}
