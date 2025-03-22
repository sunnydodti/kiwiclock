import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobWidget extends StatefulWidget {
  final bool adsEnabled;
  final String admobBannerAdUnitId;
  final String admobInterstitialAdUnitId;
  final String admobRewardedAdUnitId;

  const AdMobWidget({super.key, 
    required this.adsEnabled,
    required this.admobBannerAdUnitId,
    required this.admobInterstitialAdUnitId,
    required this.admobRewardedAdUnitId,
  });

  @override
  AdMobWidgetState createState() => AdMobWidgetState();
}

class AdMobWidgetState extends State<AdMobWidget> {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    super.initState();
    if (widget.adsEnabled) {
      _loadBannerAd();
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: widget.admobBannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {});
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          _bannerAd?.dispose();
          _bannerAd = null;
          print('BannerAd failed to load: $error');
        },
      ),
    );
    _bannerAd?.load();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
        adUnitId: widget.admobInterstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (InterstitialAd ad) {
                _interstitialAd?.dispose();
                _interstitialAd = null;
                _loadInterstitialAd();
              },
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
            _interstitialAd = null;
          },
        ));
  }

  void _loadRewardedAd() {
    RewardedAd.load(
        adUnitId: widget.admobRewardedAdUnitId,
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewardedAd = ad;
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (RewardedAd ad) {
                _rewardedAd?.dispose();
                _rewardedAd = null;
                _loadRewardedAd();
              },
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
          },
        ));
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      _loadInterstitialAd();
      print("Interstitial ad not loaded");
    }
  }

  void showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
      });
    } else {
      _loadRewardedAd();
      print("Rewarded ad not loaded");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.adsEnabled && _bannerAd != null) {
      return Container(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    }
    return SizedBox.shrink();
  }
}