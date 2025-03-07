import 'package:flutter/material.dart';
import 'package:kiwiclock/router.dart';
import 'package:provider/provider.dart';

import 'data/provider/theme_provider.dart';

class KiwiClock extends StatelessWidget {
  const KiwiClock({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Kiwi Clock',
      theme: context.watch<ThemeProvider>().theme,
      routerConfig: AppRouter.router,
      // home: const HomePage(),
    );
  }
}
