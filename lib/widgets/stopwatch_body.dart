import 'package:flutter/material.dart';
import 'package:kiwiclock/data/provider/time_provider.dart';
import 'package:provider/provider.dart';
import 'package:pwa_install/pwa_install.dart';

import 'stopwatch_event_list.dart';
import '../widgets/stopwatch_widget.dart';

class StopWatchBody extends StatelessWidget {
  const StopWatchBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (context.select((TimeProvider t) => !t.isSweView))
          Expanded(child: StopWatchWidget()),
        if (context.select((TimeProvider t) => t.isSweView))
          Expanded(child: StopwatchEventList()),
        if (PWAInstall().installPromptEnabled)
          ElevatedButton(
            onPressed: () {
              PWAInstall().promptInstall_();
            },
            child: const Text('Install PWA'),
          ),
      ],
    );
  }
}
