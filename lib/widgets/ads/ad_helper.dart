import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'ad_mob_widget.dart';
import 'ad_sense_widget.dart';

class AdHelperWidget extends StatelessWidget {
  final bool adsEnabled;
  final String admobBannerAdUnitId;
  final String admobInterstitialAdUnitId;
  final String admobRewardedAdUnitId;
  final String adsensePublisherId;
  final String adsenseAdSlotId;

  const AdHelperWidget({super.key, 
    required this.adsEnabled,
    required this.admobBannerAdUnitId,
    required this.admobInterstitialAdUnitId,
    required this.admobRewardedAdUnitId,
    required this.adsensePublisherId,
    required this.adsenseAdSlotId,
  });

  @override
  Widget build(BuildContext context) {
    if (adsEnabled) {
      if (kIsWeb) {
        return AdSenseWidget(
          adsEnabled: adsEnabled,
          adsensePublisherId: adsensePublisherId,
          adsenseAdSlotId: adsenseAdSlotId,
        );
      }
      if (Platform.isAndroid || Platform.isIOS) {
        return AdMobWidget(
          adsEnabled: adsEnabled,
          admobBannerAdUnitId: admobBannerAdUnitId,
          admobInterstitialAdUnitId: admobInterstitialAdUnitId,
          admobRewardedAdUnitId: admobRewardedAdUnitId,
        );
      }
    }
    return SizedBox.shrink();
  }
}
