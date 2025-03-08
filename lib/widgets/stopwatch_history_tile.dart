import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../data/provider/time_provider.dart';
import '../models/stopwatch_history.dart';

class StopWatchHistoryTile extends StatefulWidget {
  const StopWatchHistoryTile({
    super.key,
    required this.history,
    required this.formatter,
  });

  final StopwatchHistory history;
  final DateFormat formatter;

  @override
  State<StopWatchHistoryTile> createState() => _StopWatchHistoryTileState();
}

class _StopWatchHistoryTileState extends State<StopWatchHistoryTile> {
  bool extended = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => setState(() => extended = !extended),
      title: (widget.history.id != null) ? Text('${widget.history.id}') : null,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'End: ${widget.history.endTime != null ? widget.formatter.format(widget.history.endTime!) : 'N/A'}'),
          Text(
              'Start: ${widget.history.startTime != null ? widget.formatter.format(widget.history.startTime!) : 'N/A'}'),
          if (extended)
            Row(
              children: [
                buildDeleteButton(),
                // buildEditButton(),
                buildShareButton()
              ],
            )
        ],
      ),
      trailing: Text(elapsedText, overflow: TextOverflow.ellipsis),
    );
  }

  Expanded buildDeleteButton() {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
      child: ElevatedButton(
          onPressed: () {
            setState(() => extended = false);
            context.read<TimeProvider>().deleteStopWatchHistory(widget.history);
          },
          child: Icon(Icons.delete_outline)),
    ));
  }

  Expanded buildShareButton() {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
      child: ElevatedButton(
          onPressed: () async {
            widget.history.id ??= await context
                  .read<TimeProvider>()
                  .shareHistory(widget.history);

            Share.share(widget.history.sharableLink);
          },
          child: Icon(Icons.share_outlined)),
    ));
  }

  Expanded buildEditButton() {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
      child: ElevatedButton(onPressed: () {}, child: Icon(Icons.edit_outlined)),
    ));
  }

  String get elapsedText {
    if (widget.history.duration == null) return 'N/A';
    Duration d = widget.history.duration!;
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
