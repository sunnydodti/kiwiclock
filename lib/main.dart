import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/provider/nav_provider.dart';
import 'data/provider/theme_provider.dart';
import 'data/provider/time_provider.dart';
import 'service/startup_service.dart';

void main() async {
  await StartupService.init();
  usePathUrlStrategy();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => NavProvider()),
      ChangeNotifierProvider(create: (_) => TimeProvider()),
    ],
    child: const KiwiClock(),
  ));
}
