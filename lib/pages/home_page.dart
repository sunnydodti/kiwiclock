import 'package:flutter/material.dart';
import 'package:kiwiclock/data/provider/nav_Provider.dart';
import 'package:kiwiclock/pages/stop_watch_page.dart';
import 'package:kiwiclock/widgets/my_appbar.dart';
import 'package:kiwiclock/widgets/stopwatch_body.dart';
import 'package:kiwiclock/widgets/timer_widget.dart';
import 'package:provider/provider.dart';
import 'package:pwa_install/pwa_install.dart';

import '../data/provider/theme_provider.dart';
import '../widgets/bottom_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    NavProvider navProvider = context.watch<NavProvider>();
    return Scaffold(
      appBar: MyAppbar.build(context),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavbar(),
      body: [
        Placeholder(),
        StopWatchBody(),
      ][navProvider.index],
    );
  }
}
