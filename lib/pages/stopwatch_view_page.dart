import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:kiwiclock/models/stopwatch_history.dart';
import 'package:kiwiclock/widgets/clock_loading.dart';
import 'package:kiwiclock/widgets/my_appbar.dart';

class StopwatchViewPage extends StatefulWidget {
  final String id;

  const StopwatchViewPage({super.key, required this.id});

  @override
  State<StopwatchViewPage> createState() => _StopwatchViewPageState();
}

class _StopwatchViewPageState extends State<StopwatchViewPage> {
  Future<StopwatchHistory?> _stopwatchDataFuture = Future.value(null);

  @override
  void initState() {
    super.initState();
    _stopwatchDataFuture = _loadStopwatchData();
  }

  Future<StopwatchHistory?> _loadStopwatchData() async {
    try {
      // Replace with your actual data fetching logic.  This is a placeholder.
      await Future.delayed(const Duration(seconds: 1));
      return StopwatchHistory(
        id: widget.id,
        startTime: DateTime.now().subtract(const Duration(seconds: 60)),
        endTime: DateTime.now(),
        duration: const Duration(seconds: 60),
        createdBy: 'Test User',
        name: 'My Stopwatch',
        description: 'A test stopwatch entry',
        views: 10,
      );
    } catch (e) {
      print('Error loading stopwatch data: $e');
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
                  future: _stopwatchDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ClockLoading();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final stopwatchData = snapshot.data!;
                      return buildDetails(stopwatchData);
                    } else {
                      return Text('No data found for id: ${widget.id}}');
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

  Widget buildDetails(StopwatchHistory stopwatchData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min, // Added for better layout
      children: [
        Text(
          stopwatchData.name ?? 'Unnamed Stopwatch',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(stopwatchData.description ?? 'No description'),
        const SizedBox(height: 16),
        _buildDataTile('Duration', _formatDuration(stopwatchData.duration!)),
        _buildDataTile('Start',
            DateFormat('yyyy-MM-dd HH:mm:ss').format(stopwatchData.startTime!)),
        _buildDataTile('End',
            DateFormat('yyyy-MM-dd HH:mm:ss').format(stopwatchData.endTime!)),
        _buildDataTile('Created By', stopwatchData.createdBy ?? 'Unknown'),
        _buildDataTile('Views', (stopwatchData.views ?? 0).toString()),
      ],
    );
  }

  Widget _buildDataTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
