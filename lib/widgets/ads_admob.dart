import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdmob extends StatelessWidget {
  final BannerAd bannerAd = BannerAd(
    adUnitId: 'ca-app-pub-3598370750657058/8644169363', // Orginal
    // adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test
    size: AdSize(width: 468, height: 60),
    request: AdRequest(),
    listener: BannerAdListener(),
  );
  @override
  Widget build(BuildContext context) {
    bannerAd.load();
    final AdWidget adWidget = AdWidget(ad: bannerAd);
    return Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      child: adWidget,
      // width: bannerAd.size.width.toDouble(),
      width: MediaQuery.of(context).size.width * 1,
      height: bannerAd.size.height.toDouble(),
    );
  }
}

AppOpenAd openAd;

Future<void> openingAd() async {
  await AppOpenAd.load(
      adUnitId: 'ca-app-pub-3598370750657058/9901410710', // Orgnal
      // adUnitId: 'ca-app-pub-3940256099942544/3419835294', // Test
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(onAdLoaded: (ad) {
        print('ad is loaded');
        openAd = ad;
        // openAd.show();
        openingAdShow();
      }, onAdFailedToLoad: (error) {
        print('ad failed to load $error');
      }),
      orientation: AppOpenAd.orientationPortrait);
}

void openingAdShow() {
  if (openAd == null) {
    print('trying tto show before loading');
    openingAd();
    return;
  }

  openAd.fullScreenContentCallback =
      FullScreenContentCallback(onAdShowedFullScreenContent: (ad) {
    print('onAdShowedFullScreenContent');
  }, onAdFailedToShowFullScreenContent: (ad, error) {
    ad.dispose();
    print('failed to load $error');
    openAd = null;
    openingAd();
  }, onAdDismissedFullScreenContent: (ad) {
    ad.dispose();
    print('dismissed');
    openAd = null;
    // loadAd();
  });

  openAd.show();
}

InterstitialAd interstitialAd;

Future<void> interstitialingAd() async {
  await InterstitialAd.load(
    adUnitId: 'ca-app-pub-3598370750657058/7331087698', // Orginal
    // adUnitId: 'ca-app-pub-3940256099942544/8691691433', // Test
    request: AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
      print('ad is loaded');
      interstitialAd = ad;
      // openAd.show();
      interstitialingAdShow();
    }, onAdFailedToLoad: (error) {
      print('ad failed to load $error');
    }),
  );
}

void interstitialingAdShow() {
  if (interstitialAd == null) {
    print('trying tto show before loading');
    interstitialingAd();
    return;
  }

  interstitialAd.fullScreenContentCallback =
      FullScreenContentCallback(onAdShowedFullScreenContent: (ad) {
    print('onAdShowedFullScreenContent');
  }, onAdFailedToShowFullScreenContent: (ad, error) {
    ad.dispose();
    print('failed to load $error');
    interstitialAd = null;
    interstitialingAd();
  }, onAdDismissedFullScreenContent: (ad) {
    ad.dispose();
    print('dismissed');
    interstitialAd = null;
    // loadAd();
  });

  interstitialAd.show();
}
