import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kiwiclock/widgets/my_appbar.dart';
import 'package:kiwiclock/widgets/stopwatch_body.dart';

import '../data/provider/nav_provider.dart';
import '../widgets/ads/mobile/android/admob_banner_ad.dart';
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
        AdmobBannerAd(),
        StopWatchBody(),
      ][navProvider.index],
    );
  }
}
