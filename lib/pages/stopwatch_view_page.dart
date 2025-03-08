import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:kiwiclock/data/provider/time_provider.dart';
import 'package:kiwiclock/models/stopwatch_history.dart';
import 'package:kiwiclock/widgets/clock_loading.dart';
import 'package:kiwiclock/widgets/my_appbar.dart';
import 'package:kiwiclock/widgets/my_button.dart';
import 'package:provider/provider.dart';

import '../widgets/colored_text_box.dart';

class StopwatchViewPage extends StatefulWidget {
  final String id;

  const StopwatchViewPage({super.key, required this.id});

  @override
  State<StopwatchViewPage> createState() => _StopwatchViewPageState();
}

class _StopwatchViewPageState extends State<StopwatchViewPage> {
  StopwatchHistory? _stopwatchData;

  @override
  void initState() {
    super.initState();
  }

  Future<StopwatchHistory?> _loadStopwatchData() async {
    try {
      if (_stopwatchData != null) return _stopwatchData;
      StopwatchHistory? swh =
          await context.read<TimeProvider>().getSwhById(widget.id);
      _stopwatchData = swh;
      return swh;
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
          height: min(300, MediaQuery.of(context).size.height * 0.8),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: FutureBuilder<StopwatchHistory?>(
                  future: _loadStopwatchData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ClockLoading();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final stopwatchData = snapshot.data!;
                      return buildDetails(stopwatchData);
                    } else {
                      return buildNoDataInfo(context);
                    }
                  },
                ),
              ),
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

  Widget buildDetails(StopwatchHistory stopwatchData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min, // Added for better layout
      children: [
        buildTitle(stopwatchData),
        Divider(thickness: .2),
        if (stopwatchData.description != null) Text(stopwatchData.description!),
        const SizedBox(height: 16),
        _buildDataTile('Duration', _formatDuration(stopwatchData.duration!)),
        _buildDataTile('Start',
            DateFormat('yyyy-MM-dd HH:mm:ss').format(stopwatchData.startTime!)),
        _buildDataTile('End',
            DateFormat('yyyy-MM-dd HH:mm:ss').format(stopwatchData.endTime!)),
        if (stopwatchData.createdBy != null)
          _buildDataTile('Created By', stopwatchData.createdBy!),
        _buildDataTile('Views', (stopwatchData.views ?? 0).toString()),
      ],
    );
  }

  Text buildTitle(StopwatchHistory stopwatchData) {
    return Text(
      stopwatchData.name ?? 'Stopwatch',
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
}
