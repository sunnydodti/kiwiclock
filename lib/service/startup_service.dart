import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:pwa_install/pwa_install.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/constants.dart';

class StartupService {
  static Future<void> init() async {
    await _init();
  }

  static Future<void> _init() async {
    await _initHive();
    await _initDB();
    await _initPWA();
    await _initSupabase();
    await _initGoogleMobileAds();
  }

  static Future<void> _initHive() async {
    await Hive.initFlutter();
    await Hive.openBox(Constants.box);
  }

  static Future<void> _initDB() async {
    Box box = Hive.box(Constants.box);
  }

  static Future _initPWA() async {
    PWAInstall().setup(installCallback: () {
      debugPrint('PWA INSTALLED!');
    });
  }

  static Future _initSupabase() async {
    await Supabase.initialize(
      url: 'https://wjoedahzhxjjqzvvcaig.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Indqb2VkYWh6aHhqanF6dnZjYWlnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDEyODAzNDEsImV4cCI6MjA1Njg1NjM0MX0.kV3q4PUY6POH2Ma8dyNYGIcnW4PLXFMXqDTeibnjfis',
    );
  }

  static Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }
}
