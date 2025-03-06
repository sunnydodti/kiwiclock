import 'package:flutter/material.dart';
import 'package:pwa_install/pwa_install.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (PWAInstall().installPromptEnabled)
            ElevatedButton(
              onPressed: () {
                PWAInstall().promptInstall_();
              },
              child: const Text('Install PWA'),
            ),
        ],
      ),
    );
  }
}
