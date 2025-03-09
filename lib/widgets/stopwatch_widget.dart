import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kiwiclock/data/provider/time_provider.dart';
import 'package:kiwiclock/widgets/clock_loading.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'my_button.dart';

class StopWatchWidget extends StatefulWidget {
  const StopWatchWidget({super.key});

  @override
  State<StopWatchWidget> createState() => _StopWatchWidgetState();
}

class _StopWatchWidgetState extends State<StopWatchWidget> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(); // Create instance.
  late Timer _timer;

  void rebuild(Timer timer) {
    if (context.read<TimeProvider>().stopWatch.isRunning) {
      setState(() {});
    }
  }

  @override
  void initState() {
    _timer = _setStartTimer();
    super.initState();
  }

  Timer _setStartTimer() {
    if (context.read<TimeProvider>().stopWatch.isRunning) {
      return Timer.periodic(Duration(milliseconds: 100), rebuild);
    }

    return Timer.periodic(Duration(minutes: 1), rebuild);
  }

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _start() {
    _timer = Timer.periodic(Duration(milliseconds: 100), rebuild);
    context.read<TimeProvider>().startStopwatch();
  }

  void _pause() {
    _timer.cancel();
    context.read<TimeProvider>().pauseStopWatch();
  }

  void _stop() {
    _timer.cancel();
    context.read<TimeProvider>().stopStopWatch();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        _buildClockLoading(),
        SizedBox(height: 10),
        Text(context.select((TimeProvider t) => t.getTimeString())),
        SizedBox(height: 10),
        _buildStartButton(),
        _buildPauseButton(),
        _buildStopButton(),
        _buildShareButton(),
        _buildLinkButton(),
        Spacer(),
        _buildHistoryButton(),
      ],
    );
  }

  Widget _buildLinkButton() {
    if (context.select((TimeProvider t) {
      if (t.stopwatchEvent == null) return true;
      return t.stopwatchEvent!.id == null;
    })) {
      return SizedBox.shrink();
    }
    String link = context.select((TimeProvider t) {
      return t.stopwatchEvent!.link;
    });
    String sharableLink = context.select((TimeProvider t) {
      return t.stopwatchEvent!.sharableLink;
    });
    return MyButton(
      onPressed: () {
        print(link);
        String id = context.read<TimeProvider>().stopwatchEvent!.id!;
        context.goNamed(
          'Stopwatch View',
          pathParameters: {'id': id},
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(link, overflow: TextOverflow.ellipsis, maxLines: 2)),
          GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: sharableLink));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Copied to clipboard'),
                    duration: Durations.long2,
                  ),
                );
              },
              child: Icon(Icons.copy_outlined)),
        ],
      ),
    );
  }

  SizedBox _buildShareButton() {
    if (context.select((TimeProvider t) {
      return t.stopwatchEvent == null;
    })) {
      return SizedBox.shrink();
    }
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: ElevatedButton(
          onPressed: () async {
            String result =
                await context.read<TimeProvider>().shareCurrentSwe();
            if (mounted) {
              Share.share(
                  context.read<TimeProvider>().stopwatchEvent!.sharableLink);
            }
          },
          child: Icon(Icons.share_outlined),
        ),
      ),
    );
  }

  SizedBox _buildStopButton() {
    if (context
        .select((TimeProvider t) => t.stopWatch.elapsedMilliseconds < 1)) {
      return SizedBox.shrink();
    }
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: ElevatedButton(
          onPressed: _stop,
          child: Icon(Icons.stop_outlined),
        ),
      ),
    );
  }

  SizedBox _buildPauseButton() {
    if (context.select((TimeProvider t) => !t.stopWatch.isRunning)) {
      return SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: ElevatedButton(
          onPressed: _pause,
          child: Icon(Icons.pause_outlined),
        ),
      ),
    );
  }

  SizedBox _buildClockLoading() {
    if (context.select((TimeProvider t) => !t.stopWatch.isRunning)) {
      return SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: ClockLoading(),
      ),
    );
  }

  SizedBox _buildStartButton() {
    if (context.select((TimeProvider t) => t.stopWatch.isRunning)) {
      return SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: ElevatedButton(
          onPressed: _start,
          child: Icon(Icons.play_arrow_outlined),
        ),
      ),
    );
  }

  _buildHistoryButton() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: ElevatedButton(
          onPressed: () {
            context.read<TimeProvider>().toggleSweView();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history_outlined),
              SizedBox(width: 10),
              Text('History')
            ],
          ),
        ),
      ),
    );
  }
}
