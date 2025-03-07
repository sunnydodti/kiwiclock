import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/stopwatch_history.dart';

class StopWatchHistoryTile extends StatelessWidget {
  const StopWatchHistoryTile({
    super.key,
    required this.history,
    required this.formatter,
  });

  final StopwatchHistory history;
  final DateFormat formatter;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: (history.id != null) ? Text('${history.id}') : null,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'End: ${history.endTime != null ? formatter.format(history.endTime!) : 'N/A'}'),
          Text(
              'Start: ${history.startTime != null ? formatter.format(history.startTime!) : 'N/A'}'),
        ],
      ),
      trailing: Text(elapsedText, overflow: TextOverflow.ellipsis),
    );
  }

  String get elapsedText {
    if (history.duration == null) return 'N/A';
    Duration d = history.duration!;
    if (d.inMilliseconds < 1) return 'N/A';
    String text = '';

    if (d.inDays > 0) text += '${d.inDays}d ';
    if (d.inHours % 24 > 0) text += '${d.inHours % 24}h ';
    if (d.inMinutes % 60 > 0) text += '${d.inMinutes % 60}m ';
    if (d.inSeconds % 60 > 0) text += '${d.inSeconds % 60}s ';
    if (d.inMilliseconds % 1000 > 0) text += '${d.inMilliseconds % 1000}ms ';
    return text;
  }
}
