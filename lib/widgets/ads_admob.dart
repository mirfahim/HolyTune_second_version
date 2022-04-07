import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdmob extends StatelessWidget {
  BannerAdmob({this.bannerAd});
  final BannerAd bannerAd;
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
