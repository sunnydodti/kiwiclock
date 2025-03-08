import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../data/provider/time_provider.dart';
import '../models/stopwatch_history.dart';
import 'colored_text_box.dart';
import 'my_button.dart';

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
    Color color = Theme.of(context).colorScheme.primary;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: (extended) ? color.withAlpha(20) : null,
          child: ListTile(
            onTap: () => setState(() => extended = !extended),
            title: (widget.history.id != null)
                ? Text('${widget.history.id}')
                : null,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'End: ${widget.history.endTime != null ? widget.formatter.format(widget.history.endTime!) : 'N/A'}'),
                Text(
                    'Start: ${widget.history.startTime != null ? widget.formatter.format(widget.history.startTime!) : 'N/A'}'),
              ],
            ),
            trailing: ColoredTextBox(
              text: widget.history.elapsedText,
              color: Theme.of(context).colorScheme.primary,
              upperCase: false,
            ),
          ),
        ),
        if (extended)
          Row(
            children: [
              buildDeleteButton(),
              // buildEditButton(),
              buildShareButton()
            ],
          ),
        if (extended) _buildCopyLinkButton(),
      ],
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
            widget.history.id ??=
                await context.read<TimeProvider>().shareHistory(widget.history);

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

  Widget _buildCopyLinkButton() {
    if (widget.history.id == null) return SizedBox.shrink();
    String link = widget.history.link;
    return MyButton(
      onPressed: () {
        context.goNamed(
          'Stopwatch View',
          pathParameters: {'id': widget.history.id!},
        );
      },
      edgeInsets: EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(link, overflow: TextOverflow.ellipsis, maxLines: 2)),
          GestureDetector(
              onTap: () {
                Clipboard.setData(
                    ClipboardData(text: widget.history.sharableLink));
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
}
