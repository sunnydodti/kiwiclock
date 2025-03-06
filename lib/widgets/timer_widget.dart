import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  bool isRunning = false;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(); // Create instance.
  late Stopwatch _stopwatch;
  late Timer _timer;

  @override
  void initState() {
    _stopwatch = Stopwatch();
    _timer = Timer.periodic(Duration(microseconds: 13), (t) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    super.dispose();
  }

  void _stop() {
    if (_stopwatch.isRunning) _stopwatch.stop();
  }

  void _start() {
    if (!_stopwatch.isRunning) _stopwatch.start();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_getTimeString()),
        _buildStartButton(),
        _buildStopButton()
      ],
    );
  }

  SizedBox _buildStopButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _stop,
        child: Icon(Icons.stop_outlined),
      ),
    );
  }

  SizedBox _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _start,
        child: Icon(Icons.play_arrow_outlined),
      ),
    );
  }

  String _getTimeString() {
    var milli = _stopwatch.elapsed.inMilliseconds;

    String milliseconds = (milli % 1000)
        .toString()
        .padLeft(3, "0"); // this one for the miliseconds
    String seconds = ((milli ~/ 1000) % 60)
        .toString()
        .padLeft(2, "0"); // this is for the second
    String minutes = ((milli ~/ 1000) ~/ 60)
        .toString()
        .padLeft(2, "0"); // this is for the minute

    return "$minutes:$seconds:$milliseconds";
  }
}
