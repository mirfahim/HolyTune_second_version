import 'package:HolyTune/database/SharedPreference.dart';
import 'package:HolyTune/providers/SliderImageProvider.dart';
import 'package:HolyTune/providers/app_version.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:admob_flutter/admob_flutter.dart';
import 'auth/OTP_MOBILE/OTPFunc/stores/login_store.dart';
import 'screens/SplashScreen.dart';
import 'screens/youtubevideo/getData.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'widgets/ads_admob.dart';

// List<String> testDeviceIds = ['51FE05FBA475ED038D296BD721BCCA1D'];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // RequestConfiguration config = RequestConfiguration(
  //     testDeviceIds: <String>['51FE05FBA475ED038D296BD721BCCA1D']);
  // MobileAds.instance.updateRequestConfiguration(config);
  MobileAds.instance.initialize();

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

  openingAd();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppVersion()),
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
              return Center(child: CircularProgressIndicator());
            }
          }),
    ),
  );
}
