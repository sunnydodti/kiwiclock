import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kiwiclock/data/provider/time_provider.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class StopWatchWidget extends StatefulWidget {
  const StopWatchWidget({super.key});

  @override
  State<StopWatchWidget> createState() => _StopWatchWidgetState();
}

class _StopWatchWidgetState extends State<StopWatchWidget> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(); // Create instance.
  late Timer _timer;

  void rebuild(Timer timer) {
    if (context.read<TimeProvider>().stopwatch.isRunning) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // _timer = Timer.periodic(Duration(milliseconds: 100), rebuild);
    _timer = Timer.periodic(Duration(minutes: 1), rebuild);
    super.initState();
  }

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _stop() {
    _timer.cancel();
    context.read<TimeProvider>().stopStopWatch();
  }

  void _start() {
    _timer = Timer.periodic(Duration(milliseconds: 100), rebuild);
    context.read<TimeProvider>().startStopwatch();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(context.select((TimeProvider t) => t.getTimeString())),
        if (context.select((TimeProvider t) => !t.stopwatch.isRunning))
          _buildStartButton(),
        if (context.select((TimeProvider t) => t.stopwatch.isRunning))
          _buildPauseButton(),
        if (context.select((TimeProvider t) => t.stopwatch.isRunning))
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
  SizedBox _buildPauseButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _stop,
        child: Icon(Icons.pause_outlined),
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
}
