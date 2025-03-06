import 'package:flutter/material.dart';
import 'package:pwa_install/pwa_install.dart';

import '../widgets/stopwatch_widget.dart';

class StopWatchPage extends StatelessWidget {
  const StopWatchPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: StopWatchWidget()),
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
