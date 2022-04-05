import 'package:flutter/foundation.dart';
import '../models/Userdata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/SQLiteDbProvider.dart';
import '../utils/langs.dart';
import '../i18n/strings.g.dart';

class AppStateNotifier with ChangeNotifier {
  Userdata userdata;
  bool isUserSeenOnboardingPage = false;
  bool isDarkModeOn = false;
  bool loadArticlesImages = true;
  bool loadSmallImages = true;
  bool isLoadingTheme = true;
  bool isRtlEnabled = false;
  bool isReceievePushNotifications = true;
  int preferredLanguage = 0;
  final _langPreference = "language_preference";

  AppStateNotifier() {
    init();
  }

  init() async {
    await loadAppTheme();
    getPreferedLanguage();
    getRecieveNotifications();
    getUserData();
  }

  getUserSeenOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("user_seen_onboarding_page") != null) {
      isUserSeenOnboardingPage = prefs.getBool("user_seen_onboarding_page");
    }
  }

  setUserSeenOnboardingPage(bool seen) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("user_seen_onboarding_page", seen);
  }

  getUserData() async {
    userdata = await SQLiteDbProvider.db.getUserData();
    print("userdata " + userdata.toString());
    notifyListeners();
  }

  setUserData(Userdata _userdata) async {
    await SQLiteDbProvider.db.deleteUserData();
    await SQLiteDbProvider.db.insertUser(_userdata);
    this.userdata = _userdata;
    notifyListeners();
  }

  unsetUserData() async {
    await SQLiteDbProvider.db.deleteUserData();
    this.userdata = null;
    notifyListeners();
  }

  getPreferedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      //load app language
      preferredLanguage = prefs.getInt(_langPreference) ?? 0;
    } catch (e) {
      // quietly pass
    }
    LocaleSettings.setLocale(
        appLanguageData[AppLanguage.values[preferredLanguage]]['value']);
  }

  //app language setting
  setAppLanguage(int index) async {
    //AppLanguage _preferredLanguage = AppLanguage.values[index];
    preferredLanguage = index;
    LocaleSettings.setLocale(
        appLanguageData[AppLanguage.values[index]]['value']);
    // Here we notify listeners that theme changed
    // so UI have to be rebuild
    notifyListeners();
    // Save selected theme into SharedPreferences
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt(_langPreference, preferredLanguage);
    if (AppLanguage.values[index] == AppLanguage.Bangla) {
      setRtlEnabled(true);
    } else {
      setRtlEnabled(false);
    }
  }

  loadAppTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("app_theme") != null) {
      isDarkModeOn = prefs.getBool("app_theme");
    }
    isLoadingTheme = false;
    notifyListeners();
  }

  getAppTheme2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("app_theme") != null) {
      isDarkModeOn = prefs.getBool("app_theme");
    }
    return isDarkModeOn;
  }

  setAppTheme(bool theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkModeOn = theme;
    prefs.setBool("app_theme", theme);
    notifyListeners();
  }

  getRecieveNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("receieve_notifications") != null) {
      isReceievePushNotifications = prefs.getBool("receieve_notifications");
    }
    return isReceievePushNotifications;
  }

  setRecieveNotifications(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isReceievePushNotifications = value;
    prefs.setBool("receieve_notifications", value);
    notifyListeners();
  }

  getRtlEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("rtl_enabled") != null) {
      isRtlEnabled = prefs.getBool("rtl_enabled");
    }
    return isRtlEnabled;
  }

  setRtlEnabled(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isRtlEnabled = value;
    prefs.setBool("rtl_enabled", value);
    notifyListeners();
  }
}
