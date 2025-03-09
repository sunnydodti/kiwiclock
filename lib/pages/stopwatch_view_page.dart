import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:kiwiclock/data/provider/time_provider.dart';
import 'package:kiwiclock/models/stopwatch_event.dart';
import 'package:kiwiclock/widgets/clock_loading.dart';
import 'package:kiwiclock/widgets/my_appbar.dart';
import 'package:kiwiclock/widgets/my_button.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../extensions/stopwatch.dart';
import '../widgets/colored_text_box.dart';
import '../widgets/stopwatch_counter.dart';

class StopwatchViewPage extends StatefulWidget {
  final String id;

  const StopwatchViewPage({super.key, required this.id});

  @override
  State<StopwatchViewPage> createState() => _StopwatchViewPageState();
}

class _StopwatchViewPageState extends State<StopwatchViewPage> {
  StopwatchEvent? _stopwatchData;
  late StreamSubscription<SupabaseStreamEvent> streamSubscription;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _subscribeToUpdates();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  Future<StopwatchEvent?> _loadStopwatchData() async {
    try {
      if (_stopwatchData != null) return _stopwatchData;
      StopwatchEvent? swe =
          await context.read<TimeProvider>().getSweById(widget.id);
      _stopwatchData = swe;
      return swe;
    } catch (e) {
      return null;
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar.build(context, title: 'Stopwatch', back: true),
      body: Center(
        child: SizedBox(
          width: min(350, MediaQuery.of(context).size.width * 0.8),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _detailsBuilder(),
            ),
          ),
        ),
      ),
    );
  }

  Column buildNoDataInfo(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'The data is so shy, it didn\'t show up',
          maxLines: 2,
          overflow: TextOverflow.fade,
        ),
        SizedBox(height: 16),
        MyButton(
            onPressed: () => context.goNamed('Home'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Explore', overflow: TextOverflow.fade),
                SizedBox(width: 8),
                Icon(Icons.launch_outlined),
              ],
            ))
      ],
    );
  }

  Widget buildDetails(StopwatchEvent event) {
    if (event.endTime == null) {
      return _buildOngoingEvent(event);
    }
    return buildCompletedEvent(event);
  }

  Text buildTitle(StopwatchEvent event) {
    return Text(
      event.name ?? 'Event',
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      maxLines: 3,
      overflow: TextOverflow.fade,
    );
  }

  Widget _buildDataTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          ColoredTextBox(
              text: value, color: Theme.of(context).colorScheme.primary),
        ],
      ),
    );
  }

  void _subscribeToUpdates() {
    streamSubscription = context
        .read<TimeProvider>()
        .streamStopWatchEventById(widget.id, onDataReceived);
  }

  onDataReceived(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      setState(() => isLoading = false);
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: SelectableText('${data[0]}')));
    try {
      StopwatchEvent? swe = StopwatchEvent.fromJson(data[0]);

      setState(() {
        _stopwatchData = swe;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: SelectableText(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  Widget _buildOngoingEvent(StopwatchEvent event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        buildTitle(event),
        Divider(thickness: .2),
        if (event.description != null)
          Text(
            event.description!,
            maxLines: 5,
          ),
        const SizedBox(height: 16),
        if (!event.isPaused) ClockLoading(size: 30),
        if (!event.isPaused) const SizedBox(height: 8),
        if (!event.isPaused) StopWatchCounter(event: event),
        if (!event.isPaused) const SizedBox(height: 16),
        if (event.isPaused) Icon(Icons.pause),
        if (event.isPaused) const SizedBox(height: 8),
        if (event.isPaused) _buildElapsedText(event),
        if (event.isPaused) const SizedBox(height: 16),
        if (event.startTime != null)
          _buildDataTile(
              'Start',
              DateFormat('yyyy-MM-dd HH:mm:ss')
                  .format(event.startTime!.toLocal())),
        if (event.author != null) _buildDataTile('Author', event.author!),
        _buildDataTile('Views', event.views.toString()),
      ],
    );
  }

  Column buildCompletedEvent(StopwatchEvent event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        buildTitle(event),
        Divider(thickness: .2),
        if (event.description != null) Text(event.description!),
        const SizedBox(height: 16),
        if (event.duration.inMilliseconds > 0)
          _buildDataTile('Duration', _formatDuration(event.duration)),
        if (event.startTime != null)
          _buildDataTile(
              'Start',
              DateFormat('yyyy-MM-dd HH:mm:ss')
                  .format(event.startTime!.toLocal())),
        if (event.endTime != null)
          _buildDataTile(
              'End',
              DateFormat('yyyy-MM-dd HH:mm:ss')
                  .format(event.endTime!.toLocal())),
        if (event.author != null) _buildDataTile('Author', event.author!),
        _buildDataTile('Views', event.views.toString()),
      ],
    );
  }

  Widget _detailsBuilder() {
    if (isLoading) return SizedBox(height: 200, child: const ClockLoading());
    if (_stopwatchData == null) return buildNoDataInfo(context);
    return buildDetails(_stopwatchData!);
  }

  Widget _buildElapsedText(StopwatchEvent event) {
    Color color = Theme.of(context).colorScheme.primary;
    StopWatch stopwatch =
        StopWatch.fromMilliseconds(event.milliSecondsFromStart);

    return ColoredTextBox(
      text: stopwatch.timeString,
      color: color,
      upperCase: false,
    );
  }
}
