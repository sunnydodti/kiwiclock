import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kiwiclock/data/ad_constants.dart';

class AdmobBannerAd extends StatefulWidget {
  const AdmobBannerAd({super.key});

  @override
  State<AdmobBannerAd> createState() => _AdmobBannerAdState();
}

class _AdmobBannerAdState extends State<AdmobBannerAd> {
  BannerAd? _bannerAd;
  @override
  void initState() {
    _bannerAd = BannerAd(
      adUnitId: AdConstants.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() => _bannerAd = ad as BannerAd);
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    );
    _loadAdS();

    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd == null) return SizedBox.shrink();
    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }

  void _loadAdS() async {
    await _bannerAd?.load();
    setState(() {});
  }
}
