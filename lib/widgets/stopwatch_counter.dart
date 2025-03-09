import 'dart:async';

import 'package:flutter/material.dart';

import '../extensions/stopwatch.dart';
import '../models/stopwatch_event.dart';
import 'colored_text_box.dart';

class StopWatchCounter extends StatefulWidget {
  final StopwatchEvent event;
  const StopWatchCounter({super.key, required this.event});

  @override
  State<StopWatchCounter> createState() => _StopWatchCounterState();
}

class _StopWatchCounterState extends State<StopWatchCounter> {
  late StopWatch _stopwatch;
  late Timer _timer;

  @override
  void initState() {
    _stopwatch = StopWatch();
    _stopwatch.milliseconds = widget.event.milliSecondsFromStart;
    _stopwatch.start();
    _timer = Timer.periodic(Duration(milliseconds: 50), rebuild);

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.primary;
    return ColoredTextBox(
      text: _stopwatch.timeString,
      color: color,
      upperCase: false,
    );
  }

  void rebuild(Timer timer) {
    setState(() {});
  }
}
