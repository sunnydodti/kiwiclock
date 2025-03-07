import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiwiclock/data/provider/time_provider.dart';
import 'package:kiwiclock/models/stopwatch_history.dart';
import 'package:provider/provider.dart';

import 'stopwatch_history_tile.dart';

class StopwatchHistoryList extends StatefulWidget {
  const StopwatchHistoryList({super.key});

  @override
  State<StopwatchHistoryList> createState() => _StopwatchHistoryListState();
}

class _StopwatchHistoryListState extends State<StopwatchHistoryList> {
  @override
  Widget build(BuildContext context) {
    final list = context.select((TimeProvider t) => t.stopwatchHistories);
    final DateFormat formatter = DateFormat('yyyy-MM-dd:HH:mm:ss');
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                final history = list[index];
                return StopWatchHistoryTile(history: history, formatter: formatter);
              }),
        ),
        _buildStopwatchButton(),
      ],
    );
  }

  _buildStopwatchButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          context.read<TimeProvider>().toggleSwHView();
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
    );
  }
}
