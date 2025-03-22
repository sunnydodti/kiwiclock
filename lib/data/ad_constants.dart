import 'dart:io';

import 'package:flutter/foundation.dart';

class AdConstants {
  static String get androidAppId {
    if (kDebugMode) return 'ca-app-pub-1667237615319309/6282730525';
    return 'ca-app-pub-1667237615319309/6282730525';
  }

  static String get iosAppId {
    if (kDebugMode) return 'ca-app-pub-3940256099942544/2934735716';
    return 'ca-app-pub-3940256099942544/2934735716';
  }

  static String get bannerAdUnitId {
    if (kIsWeb) throw UnsupportedError('Unsupported platform');

    if (Platform.isAndroid) return androidAppId;
    if (Platform.isIOS) return iosAppId;

    throw UnsupportedError('Unsupported platform');
  }
}

// Android
// Item  - app ID/ad unit ID
// AdMob app ID - ca-app-pub-3940256099942544~3347511713
// Banner - ca-app-pub-3940256099942544/6300978111
// Interstitial - ca-app-pub-3940256099942544/1033173712
// Rewarded - ca-app-pub-3940256099942544/5224354917

// Ios
// Item
// app ID/ad unit ID
// AdMob app ID - ca-app-pub-3940256099942544~1458002511
// Banner - ca-app-pub-3940256099942544/2934735716
// Interstitial - ca-app-pub-3940256099942544/4411468910
// Rewarded - ca-app-pub-3940256099942544/1712485313
