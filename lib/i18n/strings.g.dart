// Generated file. Do not edit.

import 'package:flutter/material.dart';
import 'package:fast_i18n/fast_i18n.dart';

const String _baseLocale = 'en';
String _locale = _baseLocale;
Map<String, Strings> _strings = {
  'ar': StringsAr.instance,
  'en': Strings.instance,
};

/// Method A: Simple
///
/// Widgets using this method will not be updated after widget creation when locale changes.
/// Translation happens during initialization of the widget (method call of t)
///
/// Usage:
/// String translated = t.someKey.anotherKey;
Strings get t {
  return _strings[_locale];
}

/// Method B: Advanced
///
/// Reacts on locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // get t variable
/// String translated = t.someKey.anotherKey; // use t variable
class Translations {
  Translations._(); // no constructor

  static Strings of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedLocaleData>()
        .translations;
  }
}

class LocaleSettings {
  LocaleSettings._(); // no constructor

  /// use the locale of the device, fallback to default locale
  static Future<void> useDeviceLocale() async {
    _locale =
        await FastI18n.findDeviceLocale(_strings.keys.toList(), _baseLocale);

    if (_translationProviderKey.currentState != null)
      _translationProviderKey.currentState.setLocale(_locale);
  }

  /// set the locale, fallback to default locale
  static void setLocale(String locale) {
    _locale =
        FastI18n.selectLocale(locale, _strings.keys.toList(), _baseLocale);

    if (_translationProviderKey.currentState != null)
      _translationProviderKey.currentState.setLocale(_locale);
  }

  /// get the current locale
  static String get currentLocale {
    return _locale;
  }

  /// get the base locale
  static String get baseLocale {
    return _baseLocale;
  }

  /// get the supported locales
  static List<String> get locales {
    return _strings.keys.toList();
  }
}

GlobalKey<_TranslationProviderState> _translationProviderKey =
    new GlobalKey<_TranslationProviderState>();

class TranslationProvider extends StatefulWidget {
  final Widget child;
  TranslationProvider({@required this.child})
      : super(key: _translationProviderKey);

  @override
  _TranslationProviderState createState() => _TranslationProviderState();
}

class _TranslationProviderState extends State<TranslationProvider> {
  String locale = _locale;

  void setLocale(String newLocale) {
    setState(() {
      locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedLocaleData(
      translations: _strings[locale],
      child: widget.child,
    );
  }
}

class _InheritedLocaleData extends InheritedWidget {
  final Strings translations;
  _InheritedLocaleData({this.translations, Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(_InheritedLocaleData oldWidget) {
    return oldWidget.translations != translations;
  }
}

// translations

class StringsAr extends Strings {
  static StringsAr _instance = StringsAr();
  static StringsAr get instance => _instance;

  @override
  String get appname => 'HolyTune';
  @override
  String get loadingapp => 'ضبط في...';
  @override
  String get allitems => 'كل الاشياء';
  @override
  String get emptyplaylist => 'لا توجد قوائم تشغيل';
  @override
  String get notsupported => 'غير مدعوم';
  @override
  String get cleanupresources => 'تنظيف الموارد';
  @override
  String get grantstoragepermission =>
      'يرجى منح إذن الوصول إلى التخزين للمتابعة';
  @override
  String get sharefiletitle => 'شاهد أو استمع ';
  @override
  String get sharefilebody => 'عبر تطبيق HolyTune ، قم بالتنزيل الآن على ';
  @override
  String get sharetext => 'استمتع ببث غير محدود من الصوت والفيديو';
  @override
  String get sharetexthint =>
      'قم بتنزيل HolyTune ، منصة دفق الموسيقى التي تتيح لك الاستماع إلى ملايين ملفات الموسيقى من جميع أنحاء العالم. قم بالتنزيل الآن من';
  @override
  String get home => 'الصفحة الرئيسية';
  @override
  String get downloads => 'البحث في التنزيلات';
  @override
  String get albums => 'ألبومات';
  @override
  String get artists => 'الفنانين';
  @override
  String get radio => 'قنوات الراديو';
  @override
  String get hotandtrending => 'الشائع';
  @override
  String get device => 'جهاز';
  @override
  String get audiotracks => 'المسارات';
  @override
  String get playlist => 'قوائم التشغيل';
  @override
  String get bookmarks => 'إشارات مرجعية';
  @override
  String get appinfo => 'معلومات التطبيق';
  @override
  String get genres => 'جميع الأنواع';
  @override
  String get genress => 'الأنواع';
  @override
  String get moods => 'المزاج';
  @override
  String get settings => 'إعدادات';
  @override
  String get selectlanguage => 'اختار اللغة';
  @override
  String get chooseapplanguage => 'اختر لغة التطبيق';
  @override
  String get startsubscription => 'افتح الميزات المميزة';
  @override
  String get startsubscriptionhint =>
      'افتح الميزات المتميزة لبدء رحلتك إلى تجربة بث وسائط لا تنتهي أبدًا';
  @override
  String get suggestedforyou => 'اقترح لك';
  @override
  String get tracks => 'المسارات';
  @override
  String get livetvchannels => 'القنوات الحية';
  @override
  String get trendingvideos => 'مقاطع الفيديو الشائعة';
  @override
  String get trendingaudios => 'جمع';
  @override
  String get trendingvideoshint => 'فيديوهات شعبية على HolyTune';
  @override
  String get trendingaudioshint => 'صوتيات شعبية على HolyTune';
  @override
  String get newvideoshint => 'مقاطع فيديو جديدة من جميع الفئات';
  @override
  String get newaudioshint => 'صوتيات جديدة من جميع الفئات';
  @override
  String get bookmarksMedia => 'متجر كتبي';
  @override
  String get noitemstodisplay => 'لا توجد عناصر لعرضها';
  @override
  String get download => 'تحميل';
  @override
  String get addplaylist => 'أضف إلى قائمة التشغيل';
  @override
  String get bookmark => 'المرجعية';
  @override
  String get unbookmark => 'غير مرجعية';
  @override
  String get share => 'يشارك';
  @override
  String get deletemedia => 'حذف ملف';
  @override
  String get deletemediahint =>
      'هل ترغب في حذف هذا الملف الذي تم تنزيله؟ لا يمكن التراجع عن هذا الإجراء';
  @override
  String get searchhint => 'البحث في الصوتيات';
  @override
  String get performingsearch => 'البحث في الصوتيات';
  @override
  String get nosearchresult => 'لم يتم العثور على نتائج';
  @override
  String get nosearchresulthint => 'حاول إدخال كلمة رئيسية أكثر عمومية';
  @override
  String get livetvPlaylists => 'قوائم تشغيل الوسائط الحية';
  @override
  String get addtoplaylist => 'أضف إلى قائمة التشغيل';
  @override
  String get newplaylist => 'قائمة تشغيل جديدة';
  @override
  String get playlistitm => 'قائمة التشغيل';
  @override
  String get mediaaddedtoplaylist => 'تمت إضافة الوسائط إلى قائمة التشغيل.';
  @override
  String get mediaremovedfromplaylist => 'تمت إزالة الوسائط من قائمة التشغيل';
  @override
  String get clearplaylistmedias => 'مسح كافة الوسائط';
  @override
  String get deletePlayList => 'حذف قائمة التشغيل';
  @override
  String get clearplaylistmediashint =>
      'انطلق وقم بإزالة جميع الوسائط من قائمة التشغيل هذه';
  @override
  String get deletePlayListhint =>
      'هل تريد المضي قدمًا وحذف قائمة التشغيل هذه ومسح جميع الوسائط؟';
  @override
  String get comments => 'تعليقات';
  @override
  String get replies => 'الردود';
  @override
  String get reply => 'رد';
  @override
  String get logintoaddcomment => 'تسجيل الدخول لإضافة تعليق';
  @override
  String get logintoreply => 'تسجيل الدخول إلى إجابة';
  @override
  String get writeamessage => 'اكتب رسالة...';
  @override
  String get nocomments => 'لا توجد تعليقات انقر لإعادة المحاولة';
  @override
  String get errormakingcomments => 'لا يمكن معالجة التعليق في الوقت الحالي..';
  @override
  String get errordeletingcomments =>
      'لا يمكن حذف هذا التعليق في الوقت الحالي..';
  @override
  String get erroreditingcomments =>
      'لا يمكن تعديل هذا التعليق في الوقت الحالي..';
  @override
  String get errorloadingmorecomments =>
      'لا يمكن تحميل المزيد من التعليقات في الوقت الحالي..';
  @override
  String get deletingcomment => 'حذف التعليق';
  @override
  String get editingcomment => 'تحرير التعليق';
  @override
  String get deletecommentalert => 'حذف تعليق';
  @override
  String get editcommentalert => 'تعديل التعليق';
  @override
  String get deletecommentalerttext =>
      'هل ترغب في حذف هذا التعليق؟ لا يمكن التراجع عن هذا الإجراء';
  @override
  String get loadmore => 'تحميل المزيد';
  @override
  String get guestuser => 'حساب زائر';
  @override
  String get fullname => 'الاسم الكامل';
  @override
  String get emailaddress => 'عنوان بريد الكتروني';
  @override
  String get password => 'كلمة المرور';
  @override
  String get repeatpassword => 'اعد كلمة السر';
  @override
  String get register => 'يسجل';
  @override
  String get login => 'تسجيل الدخول';
  @override
  String get logout => 'تسجيل خروج';
  @override
  String get logoutfromapp => 'هل تريد الخروج من التطبيق؟';
  @override
  String get logoutfromapphint =>
      'لن تتمكن من إبداء الإعجاب بالمقالات ومقاطع الفيديو أو التعليق عليها إذا لم تقم بتسجيل الدخول.';
  @override
  String get gotologin => 'اذهب إلى تسجيل الدخول';
  @override
  String get resetpassword => 'إعادة تعيين كلمة المرور';
  @override
  String get logintoaccount => 'هل لديك حساب؟ تسجيل الدخول';
  @override
  String get emptyfielderrorhint => 'أنت بحاجة لملء جميع الحقول';
  @override
  String get invalidemailerrorhint =>
      'تحتاج إلى إدخال عنوان بريد إلكتروني صالح';
  @override
  String get passwordsdontmatch => 'كلمات السر لا تتطابق';
  @override
  String get processingpleasewait => 'Processing, Please wait...';
  @override
  String get createaccount => 'انشئ حساب';
  @override
  String get forgotpassword => 'هل نسيت كلمة السر؟';
  @override
  String get orloginwith => 'أو تسجيل الدخول باستخدام';
  @override
  String get facebook => 'Facebook';
  @override
  String get google => 'Google';
  @override
  String get moreoptions => 'المزيد من الخيارات';
  @override
  String get about => 'معلومات عنا';
  @override
  String get privacy => 'سياسة خاصة';
  @override
  String get terms => 'شروط التطبيق';
  @override
  String get rate => 'قيم التطبيق';
  @override
  String get version => 'الإصدار';
  @override
  String get pulluploadmore => 'سحب ما يصل الحمل';
  @override
  String get loadfailedretry => 'فشل التحميل! انقر فوق إعادة المحاولة!';
  @override
  String get releaseloadmore => 'الافراج لتحميل المزيد';
  @override
  String get nomoredata => 'لا مزيد من البيانات';
  @override
  String get setupprefernces => 'قم بإعداد التفضيلات الخاصة بك';
  @override
  String get receievepshnotifications => 'تلقي الإخطارات';
  @override
  String get nightmode => 'الوضع الليلي';
  @override
  String get enablertl => 'تفعيل RTL';
  @override
  String get duration => 'مدة';
  @override
  String get ok => 'موافق';
  @override
  String get retry => 'أعد المحاولة';
  @override
  String get oops => 'اوووه!';
  @override
  String get save => 'يحفظ';
  @override
  String get cancel => 'يلغي';
  @override
  String get error => 'خطأ';
  @override
  String get success => 'نجاح';
  @override
  String get skip => 'تخطى';
  @override
  String get skiplogin => 'تخطي تسجيل الدخول';
  @override
  String get skipregister => 'تخطي تسجيل';
  @override
  String get dataloaderror =>
      'تعذر تحميل البيانات المطلوبة في الوقت الحالي ، تحقق من اتصال البيانات وانقر لإعادة المحاولة.';
  @override
  String get errorReportingComment => 'الإبلاغ عن خطأ التعليق';
  @override
  String get reportingComment => 'الإبلاغ عن التعليق';
  @override
  String get reportcomment => 'خيارات التقرير';
  @override
  List<String> get reportCommentsList => [
        'المحتوى التجاري غير المرغوب فيه أو البريد العشوائي',
        'مواد إباحية أو مواد جنسية صريحة',
        'كلام يحض على الكراهية أو عنف تصويري',
        'المضايقة أو التنمر',
        'محتوى مزعج',
      ];
  @override
  String get loginrequired => 'تسجيل الدخول مطلوب';
  @override
  String get loginrequiredhint =>
      'للاشتراك في هذه المنصة ، يجب أن تقوم بتسجيل الدخول. قم بإنشاء حساب مجاني الآن أو قم بتسجيل الدخول إلى حسابك الحالي.';
  @override
  String get subscriptions => 'اشتراكات التطبيق';
  @override
  String get subscribe => 'الإشتراك';
  @override
  String get subscribehint => 'الاشتراك المطلوبة';
  @override
  String get playsubscriptionrequiredhint =>
      'تحتاج إلى الاشتراك قبل أن تتمكن من الاستماع إلى هذه الوسائط أو مشاهدتها.';
  @override
  String get previewsubscriptionrequiredhint =>
      'لقد وصلت إلى مدة المعاينة المسموح بها لهذه الوسائط. تحتاج إلى الاشتراك لمواصلة الاستماع أو مشاهدة هذه الوسائط.';
  @override
  String get next => 'التالي';
  @override
  String get done => 'البدء';
  @override
  List<String> get onboardertitle => [
        'HolyTune',
        'Music Discovery',
        'Albums & Artists',
        'Unlimited Playlists',
      ];
  @override
  List<String> get onboarderhints => [
        'Music streaming platform that lets you listen to millions of music from around the world.',
        'With the world’s largest catalog of songs, we let you discover more music you’ll love to love.',
        'Listen to your collection of albums from your favorite music artists.',
        'Create playlists of your favorited songs and videos for a wonderful listening experience.',
      ];
  @override
  String get quitapp => 'قم بإنهاء التطبيق!';
  @override
  String get quitappwarning => 'هل ترغب في إغلاق التطبيق؟';
  @override
  String get quitappaudiowarning =>
      'أنت تقوم حاليًا بتشغيل مقطع صوتي ، وسيؤدي إنهاء التطبيق إلى إيقاف تشغيل الصوت. إذا كنت لا ترغب في إيقاف التشغيل ، فما عليك سوى تصغير التطبيق باستخدام الزر الأوسط أو النقر فوق الزر موافق لإنهاء التطبيق الآن';
}

class Strings {
  static Strings _instance = Strings();
  static Strings get instance => _instance;

  String get appname => 'HolyTune';
  String get loadingapp => 'tuning in...';
  String get allitems => 'All Items';
  String get emptyplaylist => 'No Playlists';
  String get notsupported => 'Not Supported';
  String get cleanupresources => 'Cleaning up resources';
  String get grantstoragepermission =>
      'Please grant accessing storage permission to continue';
  String get sharefiletitle => 'Watch or Listen to ';
  String get sharefilebody => 'Via HolyTune App, Download now at ';
  String get sharetext => 'Enjoy unlimited Audio & Video streaming';
  String get sharetexthint =>
      'Download HolyTune, the music streaming platform that lets you listen to millions of music files from around the world. Download now at';
  String get home => 'Home';
  String get downloads => 'Search Downloads';
  String get albums => 'Albums';
  String get artists => 'Popular Artists';
  String get radio => 'Radio Channels';
  String get hotandtrending => 'Trending';
  String get device => 'Device';
  String get audiotracks => '';
  String get playlist => 'Playlists';
  String get bookmarks => 'Bookmarks';
  String get appinfo => 'App Info';
  String get genres => 'All Categories';
  String get genress => 'Genres';
  String get moods => 'Moods';
  String get settings => 'Settings';
  String get selectlanguage => 'Select Language';
  String get chooseapplanguage => 'Choose App Language';
  String get startsubscription => 'Unlock Premium Features';
  String get startsubscriptionhint =>
      'Unlock premium features to start your journey to a never-ending media streaming experience';
  String get suggestedforyou => 'Suggested for you';
  String get tracks => 'Songs';
  String get livetvchannels => 'Live Channels';
  String get trendingvideos => 'Trending Videos';
  String get trendingaudios => 'Popular Islamic Song';
  String get islamicMusic => 'Islamic Song';
  String get trending => 'Trending';
  String get popularMusic => 'Popular Music';
  String get trendingVideos => 'Trending Videos';
  String get trendingvideoshint => 'Popular Videos On HolyTune';
  String get trendingaudioshint => 'Popular Audios On HolyTune';
  String get newvideoshint => 'New Videos from all categories';
  String get newaudioshint => 'New Audios from all categories';
  String get bookmarksMedia => 'My Bookmarks';
  String get history => 'My Search History';
  String get noitemstodisplay => 'No Items To Display';
  String get download => 'Download';
  String get addplaylist => 'Add to playlist';
  String get bookmark => 'Bookmark';
  String get unbookmark => 'UnBookmark';
  String get share => 'Share';
  String get deletemedia => 'Delete File';
  String get deletemediahint =>
      'Do you wish to delete this downloaded file? This action cannot be undone.';
  String get searchhint => 'Search Audios';
  String get performingsearch => 'Searching Audios';
  String get nosearchresult => 'No results Found';
  String get nosearchresulthint => 'Try input more general keyword';
  String get livetvPlaylists => 'Live Media Playlists';
  String get addtoplaylist => 'Add to playlist';
  String get newplaylist => 'New playlist';
  String get playlistitm => 'Playlist';
  String get mediaaddedtoplaylist => 'Media added to playlist.';
  String get mediaremovedfromplaylist => 'Media removed from playlist';
  String get clearplaylistmedias => 'Clear All Media';
  String get deletePlayList => 'Delete Playlist';
  String get clearplaylistmediashint =>
      'Go ahead and remove all media from this playlist?';
  String get deletePlayListhint =>
      'Go ahead and delete this playlist and clear all media?';
  String get comments => 'Comments';
  String get replies => 'Replies';
  String get reply => 'Reply';
  String get logintoaddcomment => 'Login to add a comment';
  String get logintoreply => 'Login to reply';
  String get writeamessage => 'Write a message...';
  String get nocomments => 'No Comments found \nclick to retry';
  String get errormakingcomments => 'Cannot process commenting at the moment..';
  String get errordeletingcomments =>
      'Cannot delete this comment at the moment..';
  String get erroreditingcomments => 'Cannot edit this comment at the moment..';
  String get errorloadingmorecomments =>
      'Cannot load more comments at the moment..';
  String get deletingcomment => 'Deleting comment';
  String get editingcomment => 'Editing comment';
  String get deletecommentalert => 'Delete Comment';
  String get editcommentalert => 'Edit Comment';
  String get deletecommentalerttext =>
      'Do you wish to delete this comment? This action cannot be undone';
  String get loadmore => 'load more';
  String get guestuser => 'Guest User';
  String get fullname => 'Type Your Name';
  String get emailaddress => 'Email Address';
  String get password => 'Password';
  String get repeatpassword => 'Repeat Password';
  String get register => 'Register';
  String get login => 'Login';
  String get logout => 'Logout';
  String get logoutfromapp => 'Logout from app?';
  String get logoutfromapphint =>
      'You wont be able to like or comment on articles and videos if you are not logged in.';
  String get gotologin => 'Go to Login';
  String get resetpassword => 'Reset Password';
  String get logintoaccount => 'Already have an account? Login';
  String get emptyfielderrorhint => 'You need to fill all the fields';
  String get confirmOtpFirst =>
      'You need to confirm the OTP which was sent to your mail. Thanks';
  String get invalidemailerrorhint => 'You need to enter a valid email address';
  String get passwordsdontmatch => 'Passwords dont match';
  String get processingpleasewait => 'Processing, Please wait...';
  String get createaccount => 'Create an account';
  String get forgotpassword => 'Forgot Password?';
  String get orloginwith => 'Or Login With';
  String get facebook => 'Facebook';
  String get google => 'Google';
  String get moreoptions => 'More Options';
  String get about => 'About Us';
  String get privacy => 'Privacy Policy';
  String get terms => 'App Terms';
  String get rate => 'Rate App';
  String get version => 'Version';
  String get pulluploadmore => 'pull up load';
  String get loadfailedretry => 'Load Failed!Click retry!';
  String get releaseloadmore => 'release to load more';
  String get nomoredata => 'No more Data';
  String get setupprefernces => 'Setup Your Preferences';
  String get receievepshnotifications => 'Recieve Notifications';
  String get nightmode => 'Night Mode';
  String get enablertl => 'Enable RTL';
  String get duration => 'Duration';
  String get ok => 'Ok';
  String get retry => 'RETRY';
  String get oops => 'Ooops!';
  String get save => 'Save';
  String get cancel => 'Cancel';
  String get error => 'Error';
  String get success => 'Success';
  String get skip => 'Skip';
  String get skiplogin => 'Skip Login';
  String get skipregister => 'Skip Registration';
  String get loginPassage =>
      'Create or access your profile and enjoy a lot of features.';
  String get loginIntro => 'Start Verification With Your Phone';
  String get dataloaderror =>
      'Could not load requested data at the moment, check your data connection and click to retry.';
  String get errorReportingComment => 'Error Reporting Comment';
  String get reportingComment => 'Reporting Comment';
  String get reportcomment => 'Report Options';
  List<String> get reportCommentsList => [
        'Unwanted commercial content or spam',
        'Pornography or sexual explicit material',
        'Hate speech or graphic violence',
        'Harassment or bullying',
        'Disturbing Content',
      ];
  String get loginrequired => 'Login Required';
  String get loginrequiredhint =>
      'To subscribe on this platform, you need to be logged in. Create a free account now or log in to your existing account.';
  String get subscriptions => 'App Subscriptions';
  String get subscribe => 'SUBSCRIBE';
  String get subscribehint => 'Subscription Required';
  String get playsubscriptionrequiredhint =>
      'You need to subscribe before you can listen to or watch this media.';
  String get previewsubscriptionrequiredhint =>
      'You have reached the allowed preview duration for this media. You need to subscribe to continue listening or watching this media.';
  String get next => 'NEXT';
  String get done => 'GET STARTED';
  List<String> get onboardertitle => [
        'HolyTune',
        'Music Discovery',
        'Albums & Artists',
        'Unlimited Playlists',
      ];
  List<String> get onboarderhints => [
        'Music streaming platform that lets you listen to millions of music from around the world.',
        'With the world’s largest catalog of songs, we let you discover more music you’ll love to love.',
        'Listen to your collection of albums from your favorite music artists.',
        'Create playlists of your favorited songs and videos for a wonderful listening experience.',
      ];
  String get quitapp => 'Quit App!';
  String get quitappwarning => 'Do you wish to close the app?';
  String get quitappaudiowarning => 'Are you sure you want to quit the App?';
}
