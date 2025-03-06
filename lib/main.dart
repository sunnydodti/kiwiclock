import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/provider/nav_Provider.dart';
import 'data/provider/theme_provider.dart';
import 'pages/home_page.dart';
import 'service/startup_service.dart';

void main() async {
  await StartupService.init();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => NavProvider()),
    ],
    child: const KiwiClock(),
  ));
}

class KiwiClock extends StatelessWidget {
  const KiwiClock({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kiwi Clock',
      theme: context.watch<ThemeProvider>().theme,
      home: const HomePage(),
    );
  }
}
