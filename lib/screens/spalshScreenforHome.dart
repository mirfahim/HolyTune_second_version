import 'dart:async';
import 'package:HolyTune/database/SharedPreference.dart';
import 'package:HolyTune/providers/AppStateNotifier.dart';
import 'package:HolyTune/screens/TabBarPage.dart';
import 'package:HolyTune/screens/unityAds/unity_ads.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class SplashScreenHome extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenHome> {
  PackageInfo packageInfo;
  AppStateNotifier appState;
  getPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    // print("VERSION__FROM___SPLASH___${packageInfo.version}");
    setState(() {});
  }
  Map<String, bool> placements = {
    AdManager.interstitialVideoAdPlacementId: true,
    AdManager.rewardedVideoAdPlacementId: false,
  };
  void _loadAd(String placementId) {
    UnityAds.load(
      placementId: placementId,
      onComplete: (placementId) {
        print('Load Complete $placementId');
        setState(() {
          placements[placementId] = true;
        });
      },
      onFailed: (placementId, error, message) => print('Load Failed $placementId: $error $message'),
    );
  }
  void _loadAds() {
    for (var placementId in placements.keys) {
      _loadAd(placementId);
    }
  }
  @override
  void initState() {
    getPackageInfo();
    super.initState();
    UnityAds.init(
      gameId: AdManager.gameId,
      testMode: false,
      onComplete: () {
        print('Initialization Complete');
        _loadAds();
      },
      onFailed: (error, message) => print('Initialization Failed: $error $message'),
    );
    bool loginState = SharedPref.to.prefss.getBool("loggedin");
    SharedPref.loginState = loginState;

    //  print("___LOGIN___STATE___BRO___$loginState");
    // print(SharedPref.loginState);
    String profileName = SharedPref.to.prefss.getString("profileName");
    String profilePhn = SharedPref.to.prefss.getString("profilePhn");
    String profileImage = SharedPref.to.prefss.getString("imageKey");

    if (profileName == null) {
      SharedPref.profileName = "there";
    } else {
      SharedPref.profileName = profileName;
    }
    if (profileImage == null) {
      SharedPref.imageProfile = "";
    } else {
      SharedPref.imageProfile = profileImage;
    }

    if (profilePhn == null) {
      SharedPref.profilePhn = "";
    } else {
      SharedPref.profilePhn = profilePhn;
    }

    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyTabHomePage(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppStateNotifier>(context);
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    print("first");
    return Image(
        fit: BoxFit.cover, image: AssetImage('assets/images/Image-05.jpg'));
  }
}
