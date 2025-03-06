import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_install/pwa_install.dart';

import '../data/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

  AppBar _buildAppBar() {
    Icon icon = Theme.of(context).brightness == Brightness.light
        ? Icon(Icons.light_mode_outlined)
        : Icon(Icons.dark_mode_outlined);
    return AppBar(
      title: Text('Kiwi Clock'),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
            icon: icon),
      ],
    );
  }
}
