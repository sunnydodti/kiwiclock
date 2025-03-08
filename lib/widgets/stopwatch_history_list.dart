import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiwiclock/data/provider/time_provider.dart';
import 'package:provider/provider.dart';

import 'stopwatch_history_tile.dart';

class StopwatchEventList extends StatefulWidget {
  const StopwatchEventList({super.key});

  @override
  State<StopwatchEventList> createState() => _StopwatchEventListState();
}

class _StopwatchEventListState extends State<StopwatchEventList> {
  @override
  Widget build(BuildContext context) {
    final list = context.watch<TimeProvider>().stopwatchEvents;
    final DateFormat formatter = DateFormat('yyyy-MM-dd:HH:mm:ss');
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                final event = list[index];
                return StopWatchEventTile(
                    event: event, formatter: formatter);
              }),
        ),
        _buildStopwatchButton(),
      ],
    );
  }

  _buildStopwatchButton() {
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
              Icon(Icons.timer_outlined),
              SizedBox(width: 10),
              Text('Stopwatch')
            ],
          ),
        ),
      ),
    );
  }
}
