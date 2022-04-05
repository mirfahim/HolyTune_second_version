import 'package:HolyTune/database/SharedPreference.dart';
import 'package:HolyTune/providers/SliderImageProvider.dart';
import 'package:HolyTune/screens/spalshScreenforHome.dart';
import 'package:flutter/material.dart';
import 'MyApp.dart';
import './providers/AppStateNotifier.dart';
import 'package:provider/provider.dart';
import './providers/BookmarksModel.dart';
import './providers/PlaylistsModel.dart';
import './providers/AudioPlayerModel.dart';
import './providers/DownloadsModel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/HomePage.dart';
import './screens/OnboardingPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'auth/OTP_MOBILE/OTPFunc/stores/login_store.dart';
import 'screens/SplashScreen.dart';
import 'screens/youtubevideo/listViewPage.dart';
import 'screens/youtubevideo/getData.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();
  //await Admob.requestTrackingAuthorization(); #uncomment out for IOS
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
  await FlutterDownloader.initialize(debug: true);
  await SharedPref.to.initial();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  Future<Widget> getFirstScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("user_seen_onboarding_page") == null ||
        prefs.getBool("user_seen_onboarding_page") == false) {
      return SplashScreen(); //OnboardingPage
    } else {
      return SplashScreenHome();
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateNotifier()),
        ChangeNotifierProvider(create: (_) => BookmarksModel()),
        ChangeNotifierProvider(create: (_) => PlaylistsModel()),
        ChangeNotifierProvider(create: (_) => AudioPlayerModel()),
        ChangeNotifierProvider(create: (_) => DownloadsModel()),
        ChangeNotifierProvider(create: (_) => SliderImageProvider()),
        Provider<GetData>(create: (_) => GetData()),
        Provider<LoginStore>(
          create: (_) => LoginStore(),
        ),
      ],
      child: FutureBuilder<Widget>(
          future: getFirstScreen(), //returns bool
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return MyApp(defaultHome: snapshot.data);
            } else {
              return const Center(child: CupertinoActivityIndicator());
            }
          }),
    ),
  );
}
