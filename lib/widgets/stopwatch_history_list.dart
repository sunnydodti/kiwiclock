import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiwiclock/data/provider/time_provider.dart';
import 'package:provider/provider.dart';

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
                return ListTile(
                  title: Text(
                      'Start Time: ${history.startTime != null ? formatter.format(history.startTime!) : 'N/A'}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'End Time: ${history.endTime != null ? formatter.format(history.endTime!) : 'N/A'}'),
                      Text(
                          'Duration: ${history.duration != null ? '${history.duration!.inSeconds} seconds' : 'N/A'}'),
                    ],
                  ),
                );
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
