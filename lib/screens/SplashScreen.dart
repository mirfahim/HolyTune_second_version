import 'dart:async';

import 'package:HolyTune/database/SharedPreference.dart';
import 'package:HolyTune/providers/AppStateNotifier.dart';
import 'package:flutter/material.dart';

import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import 'OnboardingPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String profileName;
  PackageInfo packageInfo;
  AppStateNotifier appState;
  getPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    // print("VERSION__FROM___SPLASH___${packageInfo.version}");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPackageInfo();
    bool loginState = SharedPref.to.prefss.getBool("loggedin");
    SharedPref.loginState = loginState;

    // print("___LOGIN___STATE___BRO___$loginState");
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

    SharedPref.profileName = "there";
    Timer(
        Duration(seconds: 4),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OnboardingPage(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppStateNotifier>(context);
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    print("bbbb");
    return Image(
      fit: BoxFit.cover,
      image: AssetImage('assets/images/Image-05.jpg'),
    );
  }
}
