import 'dart:convert';
import 'dart:io';

import 'package:HolyTune/database/SharedPreference.dart';
import 'package:HolyTune/models/package/packageModel.dart';

import 'package:HolyTune/screens/TabBarPage.dart';
import 'package:HolyTune/screens/spalshScreenforHome.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/payment_system/spCheckoutModel.dart';
import '../models/payment_system/spTokenModel.dart';
import '../utils/img.dart';
import '../providers/MoodsModel.dart';
import '../screens/MoodsDrawerScreen.dart';
import '../screens/Settings.dart';
import '../providers/ArtistsModel.dart';
import '../screens/ArtistsDrawerScreen.dart';
import '../audio_player/miniPlayer.dart';
import '../providers/AlbumsModel.dart';
import '../screens/AlbumsDrawerScreen.dart';
import '../providers/AudioPlayerModel.dart';
import '../providers/MediaScreensModel.dart';
import '../providers/AudioScreensModel.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import '../auth/LoginScreen.dart';
import '../utils/TextStyles.dart';
import '../i18n/strings.g.dart';
import '../utils/my_colors.dart';
import '../models/Userdata.dart';
import 'package:flutter/cupertino.dart';
import '../providers/AppStateNotifier.dart';
import '../screens/MediaScreen.dart';
import '../screens/AudioScreen.dart';
import '../screens/BookmarksScreen.dart';
import '../screens/PlaylistsScreen.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../widgets/ads_admob.dart';
import 'checkout/checkout.dart';

class MusicTabPage extends StatefulWidget {
  // HomePage({Key key}) : super(key: key,  );

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MusicTabPage> {
  @override
  Widget build(BuildContext context) {
    return HomePageItem();
  }
}

class HomePageItem extends StatefulWidget {
  HomePageItem({
    Key key,
  }) : super(key: key);

  @override
  _HomePageItemState createState() => _HomePageItemState();
}

class _HomePageItemState extends State<HomePageItem> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  int currentIndex = 0;
  List<Package> _packages = [];

  void onDrawerItemClicked(int indx) {
    Navigator.pop(context);
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        currentIndex = indx;

        SharedPref.settingAppbar = true;
      });
    });
  }

  AppStateNotifier appState;

  Future<void> _handleSignOut() async {
    try {
      await googleSignIn.signOut();
    } catch (error) {
      print(error);
    }
  }

  Future<void> showLogoutAlert() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(t.logoutfromapp),
              content: Text(t.logoutfromapphint),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: false,
                  child: Text(t.ok),
                  onPressed: () {
                    Navigator.of(context).pop();
                    appState.unsetUserData();
                    _handleSignOut();
                  },
                ),
                CupertinoDialogAction(
                  isDefaultAction: false,
                  child: Text(t.cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  openBrowserTab(String url) async {
    await FlutterWebBrowser.openWebPage(
        url: url, androidToolbarColor: MyColors.primary);
  }

  @override
  void initState() {
    print(
        "------------------------------Music Page Ad Section------------------------------");
    interstitialingAd();
    print(
        "------------------------------Music Page Ad Section------------------------------");
    getPackages();
    // _checkVersion();
    super.initState();
  }

  var serverVersion;
  var newVersion;
  var status;

  void _checkVersion() async {
    HttpClient()
        .getUrl(Uri.parse(
            'https://holytune.s3.ap-southeast-1.amazonaws.com/version.txt'))
        .then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) {
      response.transform(new Utf8Decoder()).listen((s) {
        serverVersion = s;
        print("__________NEW____SERVER_____VERSION____$serverVersion");
      });
    });

    final newVersion = NewVersion(
      iOSId: "com.holytune.app",
      androidId: "com.holytune.app",
    );
    final status = await newVersion.getVersionStatus();
    if (status.localVersion == serverVersion) {
      //  print("deviceVersion " + status.localVersion);
    } else {
      // print("deviceVersion " + status.localVersion);
      // print("storeVersion " + status.storeVersion);
      // print("serverVersion " + serverVersion);
      newVersion.showUpdateDialog(
          context: context,
          dialogText:
              "Update your Holytune App from Google Playstore and Appbajar",
          dismissButtonText: "AppBajar",
          dismissAction: () async {
            const url = 'https://appbajar.com/en/app/com.holytune.app';

            if (await canLaunch(url)) {
              await launch(url, forceWebView: true);
            } else {
              throw 'Could not launch $url';
            }
          },
          updateButtonText: "Playstore",
          versionStatus: status);
    }
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppStateNotifier>(context);

    Userdata userdata = appState.userdata;

    return WillPopScope(
      onWillPop: () async {
        if (Provider.of<AudioPlayerModel>(context, listen: false)
                .currentMedia !=
            null) {
          return (await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(t.quitapp),
                  content: Text(t.quitappaudiowarning),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(t.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<AudioPlayerModel>(context, listen: false)
                            .cleanUpResources();
                        Navigator.of(context).pop(true);
                      },
                      child: Text(t.ok),
                    ),
                  ],
                ),
              )) ??
              false;
        } else {
          return (await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(t.quitapp),
                  content: Text(t.quitappwarning),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(t.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(t.ok),
                    ),
                  ],
                ),
              )) ??
              false;
        }
      },
      child: LoadingOverlay(
        color: Colors.blue.shade200,
        isLoading: _isLoading,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Center(
              child: AppBar(
                elevation: 0,
                backgroundColor: appState.isDarkModeOn != true
                    ? Colors.black54
                    : Colors.black54,
                title: Row(
                  children: [
                    const Spacer(),
                    const Icon(
                      Icons.notification_important_rounded,
                      color: Colors.white,
                    )
                  ],
                ),
                actions: <Widget>[
                  // IconButton(
                  //     icon: Icon(Icons.cloud_download),
                  //     onPressed: (() {
                  //       Navigator.pushNamed(context, Downloader.routeName,
                  //           arguments: ScreenArguements(
                  //             position: 0,
                  //             items: null,
                  //           ));
                  //     })),
                  // IconButton(
                  //     icon: const Icon(Icons.settings),
                  //     onPressed: (() {
                  //       Route route =
                  //           MaterialPageRoute(builder: (c) => SettingsScreen());
                  //       Navigator.pushReplacement(context, route);
                  //       setState(() {
                  //         SharedPref.settingAppbar = false;
                  //       });
                  //     }))
                ],
              ),
            ),
          ),
          // bottomNavigationBar: CustomBottomNavBar(),
          body: Column(
            children: <Widget>[
              Expanded(child: buildPageBody(currentIndex, userdata)),
              MiniPlayer(),
              // Banneradmob(),
            ],
          ),
          drawer: SafeArea(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              width: 250,
              child: Drawer(
                key: scaffoldKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 190,
                        width: double.infinity,
                        //padding: EdgeInsets.all(10),
                        // color: Colors.lightBlue,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: double.infinity,
                              width: double.infinity,
                              child: Image.asset(
                                Img.get(""),
                                fit: BoxFit.fill,
                              ),
                            ),
                            Container(
                              //color: Colors.black38,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                  height: 25,
                                ),
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(45),
                                    child: GestureDetector(
                                      onTap: () {
                                        print("AVATAR PIC");
                                        print(SharedPref.imageProfile);
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "https://adminapplication.com/uploads/participants/" +
                                                SharedPref.imageProfile,
                                        imageBuilder: (context, imageProvider) {
                                          print(
                                              "MY___AVATAR___DP___${SharedPref.imageProfile}");
                                          return Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        },
                                        placeholder: (context, url) =>
                                            const Center(
                                                child:
                                                    CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Center(
                                          child: Container(
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: Image(
                                                image: AssetImage(
                                                  Img.get(
                                                      "holy_tune_logo_512_blue_bg.png"),
                                                ),
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //   Text("${SharedPref.phoneNO}"),
                                Container(height: 10),
                                SharedPref.profileName == "there"
                                    ? const Text("")
                                    : Text(
                                        "${SharedPref.profileName},",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'RobotoMono'),
                                      ),
                                Container(height: 05),
                                SharedPref.profileName == ""
                                    ? const Text("")
                                    : Text("${SharedPref.profilePhn}",
                                        style: const TextStyle(
                                            color: Colors.white)),
                                Container(height: 05),

                                SizedBox(
                                  height: 30,
                                  width: 130,
                                  child: ElevatedButton(
                                    child: Text(
                                      SharedPref.loginState == false
                                          ? "Logout"
                                          : "Login",
                                      //  userdata == null ? t.login : t.logout,
                                      style: TextStyles.headline(context)
                                          .copyWith(
                                              color: Colors.white,
                                              fontSize: 14),
                                    ),
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: const BorderSide(
                                                    color: Colors.white)))),

                                    //style: ButtonStyle(backgroundColor: MyColors.accent,),

                                    onPressed: () {
                                      if (SharedPref.loginState == false) {
                                        SharedPref.to.prefss.remove("loggedin");
                                        SharedPref.to.prefss
                                            .remove("profileName");
                                        SharedPref.to.prefss
                                            .remove("profilePhn");
                                        SharedPref.to.prefss.remove("email");
                                        SharedPref.to.prefss.remove("imageKey");
                                        Route route = MaterialPageRoute(
                                            builder: (c) => SplashScreenHome());
                                        Navigator.pushReplacement(
                                            context, route);
                                      } else {
                                        Navigator.pushNamed(
                                            context, LoginScreen.routeName);
                                      }
                                      // if (userdata != null) {
                                      //   showLogoutAlert();
                                      // } else {
                                      //   Navigator.pushNamed(
                                      //       context, LoginScreen.routeName);
                                      // }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: new BorderRadius.only(
                              bottomLeft: const Radius.circular(20.0),
                              bottomRight: const Radius.circular(20.0),
                            )),
                      ),
                      Container(
                        height: 45,
                        color: currentIndex == 0
                            ? (Theme.of(context).scaffoldBackgroundColor)
                            : (Theme.of(context).scaffoldBackgroundColor),
                        child: ListTile(
                          title: Text(t.home,
                              style: TextStyles.subhead(context).copyWith(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                          leading: Container(
                              height: 25,
                              width: 25,
                              decoration: const BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                LineAwesomeIcons.home,
                                size: 20.0,
                                color: Colors.white,
                              )),
                          onTap: () {
                            onDrawerItemClicked(0);
                          },
                        ),
                      ),
                      Container(
                        height: 45,
                        color: currentIndex == 1
                            ? (Theme.of(context).scaffoldBackgroundColor)
                            : (Theme.of(context).scaffoldBackgroundColor),
                        child: ListTile(
                          title: Text(t.albums,
                              style: TextStyles.subhead(context).copyWith(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                          leading: Container(
                              height: 25,
                              width: 25,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.album,
                                size: 20.0,
                                color: Colors.white,
                              )),
                          onTap: () {
                            onDrawerItemClicked(1);
                          },
                        ),
                      ),
                      Container(
                        height: 45,
                        color: currentIndex == 2
                            ? (Theme.of(context).scaffoldBackgroundColor)
                            : (Theme.of(context).scaffoldBackgroundColor),
                        child: ListTile(
                          title: Text(t.artists,
                              style: TextStyles.subhead(context).copyWith(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                          leading: Container(
                              height: 25,
                              width: 25,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.people,
                                size: 20.0,
                                color: Colors.white,
                              )),
                          onTap: () {
                            onDrawerItemClicked(2);
                          },
                        ),
                      ),
                      Container(
                        height: 45,
                        color: currentIndex == 3
                            ? (Theme.of(context).scaffoldBackgroundColor)
                            : (Theme.of(context).scaffoldBackgroundColor),
                        child: ListTile(
                          title: Text(t.audiotracks,
                              style: TextStyles.subhead(context).copyWith(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                          leading: Container(
                              height: 25,
                              width: 25,
                              decoration: const BoxDecoration(
                                color: Colors.pink,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(LineAwesomeIcons.music,
                                  size: 20.0, color: Colors.white)),
                          onTap: () {
                            onDrawerItemClicked(3);
                          },
                        ),
                      ),
                      Container(
                        height: 45,
                        color: currentIndex == 4
                            ? (Theme.of(context).scaffoldBackgroundColor)
                            : (Theme.of(context).scaffoldBackgroundColor),
                        child: ListTile(
                          title: Text(t.trendingaudios,
                              style: TextStyles.subhead(context).copyWith(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                          leading: Container(
                              height: 25,
                              width: 25,
                              decoration: const BoxDecoration(
                                color: Colors.purple,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.trending_up_outlined,
                                  size: 20.0, color: Colors.white)),
                          onTap: () {
                            onDrawerItemClicked(4);
                          },
                        ),
                      ),
                      Container(
                        height: 45,
                        color: currentIndex == 5
                            ? (Theme.of(context).scaffoldBackgroundColor)
                            : (Theme.of(context).scaffoldBackgroundColor),
                        child: ListTile(
                          title: Text(t.moods,
                              style: TextStyles.subhead(context).copyWith(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                          leading: Container(
                              height: 25,
                              width: 25,
                              decoration: const BoxDecoration(
                                color: Colors.cyan,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.emoji_emotions,
                                  size: 20.0, color: Colors.white)),
                          onTap: () {
                            onDrawerItemClicked(5);
                          },
                        ),
                      ),
                      Container(
                        height: 45,
                        color: currentIndex == 6
                            ? (Theme.of(context).scaffoldBackgroundColor)
                            : (Theme.of(context).scaffoldBackgroundColor),
                        child: ListTile(
                          title: Text(t.playlist,
                              style: TextStyles.subhead(context).copyWith(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                          leading: Container(
                            height: 25,
                            width: 25,
                            decoration: const BoxDecoration(
                              color: Colors.greenAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.playlist_play,
                                size: 20.0, color: Colors.white),
                          ),
                          onTap: () {
                            onDrawerItemClicked(6);
                          },
                        ),
                      ),
                      Container(
                        height: 45,
                        color: currentIndex == 7
                            ? (Theme.of(context).scaffoldBackgroundColor)
                            : (Theme.of(context).scaffoldBackgroundColor),
                        child: ListTile(
                          title: Text(t.bookmarks,
                              style: TextStyles.subhead(context).copyWith(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                          leading: Container(
                              height: 25,
                              width: 25,
                              decoration: const BoxDecoration(
                                color: Colors.lightGreen,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(LineAwesomeIcons.bookmark,
                                  size: 20.0, color: Colors.white)),
                          onTap: () {
                            onDrawerItemClicked(7);
                          },
                        ),
                      ),
                      Container(
                        height: 55,
                        color: currentIndex == 8
                            ? (Theme.of(context).scaffoldBackgroundColor)
                            : (Theme.of(context).scaffoldBackgroundColor),
                        child: ListTile(
                          title: Text(t.settings,
                              style: TextStyles.subhead(context).copyWith(
                                  //color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                          leading: Container(
                              height: 25,
                              width: 25,
                              decoration: const BoxDecoration(
                                color: Colors.lightBlueAccent,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.settings,
                                  size: 20.0, color: Colors.white)),
                          onTap: () {
                            onDrawerItemClicked(8);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPageBody(int currentIndex, Userdata userdata) {
    var _crossAxisSpacing = 8;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 4;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight = 70;
    var _aspectRatio = _width / cellHeight;
    if (currentIndex == 0) {
      return ListView(
        //physics: BouncingScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Enjoy Unlimited Music And Videos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Route route =
                        // MaterialPageRoute(builder: (c) => MyAppAuth());
                        // Navigator.pushReplacement(context, route);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.white10,
                        //color: Theme.of(context).scaffoldBackgroundColor,
                        child: SizedBox(
                          height: 90,
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.file_download,
                                color: Colors.blue,
                              ),
                              const Text("Downloads"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Route route =
                            MaterialPageRoute(builder: (c) => MyTabHomePage());
                        Navigator.pushReplacement(context, route);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.white10,
                        child: SizedBox(
                          height: 90,
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.album,
                                color: Colors.yellow,
                              ),
                              const Text("Album"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.white10,
                        child: SizedBox(
                          height: 90,
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.music_note_rounded,
                                color: Colors.cyan,
                              ),
                              const Text("Songs"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Route route =
                        // MaterialPageRoute(builder: (c) => HomePage(login: false,));
                        // Navigator.pushReplacement(context, route);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.white10,
                        child: SizedBox(
                          height: 90,
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.favorite_border,
                                color: Colors.red,
                              ),
                              const Text("Favourite"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Route route =
                        // MaterialPageRoute(builder: (c) => MyTabHomePage());
                        // Navigator.pushReplacement(context, route);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.white10,
                        child: SizedBox(
                          height: 90,
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.playlist_play_outlined,
                                color: Colors.green,
                              ),
                              const Text("Playlists"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.white10,
                        child: SizedBox(
                          height: 90,
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.supervised_user_circle_outlined,
                                  color: Colors.purple),
                              const Text("Artist"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: SizedBox(
              height: 230,
              child: ListView.builder(
                  itemCount: iconlist.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Icon(
                            iconlist[index],
                            color: colorList[index],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                titleList[index],
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                subTitleList[index],
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white10.withOpacity(0.5),
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: ListTile(
              title: Text(
                "Select Premium Plan",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                "Ad-free,unlimited offline downloads and playlist.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white60,
                ),
              ),
            ),
          ),
          _packages.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _packages.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                    ),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 35),
                            title: Text(
                              _packages[index].packageName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              _packages[index].amount.toString() + " BDT",
                              style: TextStyle(
                                color: Colors.white38,
                              ),
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isLoading = true;
                                });
                                // if (SharedPref.loginState == false) {
                                // Route route = MaterialPageRoute(
                                //     builder: (c) => SplashScreenHome());
                                callPayment(
                                    _packages[index].amount.toString(),
                                    const Uuid().v1(),
                                    "Testing User",
                                    "Tasnuva Address",
                                    "01645772748");
                                // } else {
                                //   Navigator.pushNamed(context, LoginScreen.routeName);
                                // }
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                      color: Color(0xFF78C1FD),
                                    ),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Color(0xFF0470C9),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "get  plan".toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      );
    }

    if (currentIndex == 1) {
      return ChangeNotifierProvider(
        create: (context) => AlbumsModel(),
        child: AlbumsDrawerScreen(),
      );
    }

    if (currentIndex == 2) {
      return ChangeNotifierProvider(
        create: (context) => ArtistsModel(),
        child: ArtistsDrawerScreen(),
      );
    }

    if (currentIndex == 4) {
      return ChangeNotifierProvider(
        create: (context) => MediaScreensModel(userdata),
        child: MediaScreen(t.hotandtrending),
      );
    }

    if (currentIndex == 3) {
      return ChangeNotifierProvider(
        create: (context) => new AudioScreensModel(userdata),
        child: AudioScreen(t.audiotracks),
      );
    }

    if (currentIndex == 5) {
      return ChangeNotifierProvider(
        create: (context) => new MoodsModel(),
        child: MoodsDrawerScreen(),
      );
    }

    if (currentIndex == 6) {
      return PlaylistsScreen(t.playlist);
    }

    if (currentIndex == 7) {
      return BookmarksScreen(t.bookmarks);
    }

    if (currentIndex == 8) {
      return SettingsScreen();
    }

    return Container();
  }

  Widget appBar() {
    return SizedBox(
      height: AppBar().preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
            ),
          ),
          const Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Flutter UI',
                  style: TextStyle(
                    fontSize: 22,
                    color: MyColors.grey_95,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
              color: Colors.white,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(AppBar().preferredSize.height),
                  child: const Icon(
                    Icons.dashboard,
                    color: MyColors.grey_95,
                  ),
                  onTap: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              title: const Text("Wifi"),
              content: const Text("Wifi not detected. Please activate it."),
            ));
  }

  callPayment(String amount, String paymentId, String customerName,
      String customerAddress, String customerPhone) async {
    print("calling surjopay api");
    var url = Uri.parse('https://sandbox.shurjopayment.com/api/get_token');
    try {
      var response = await http.post(
        url,
        body:
            json.encode({"username": "sp_sandbox", "password": "pyyk97hu&6u6"}),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
      );
      // var jsonResponse = json.decode(response.body.toString());

      if (response.statusCode == 200) {
        SpTokenModel spTokenModel =
            spTokenModelFromJson(response.body.toString());

        // print("token: ${spTokenModel.token}");
        // print("storeId: ${spTokenModel.storeId}");
        // print("executeUrl: ${spTokenModel.executeUrl}");
        /**Procced Payment within Time Range  */
        invockedPayment(
            spTokenModel.token,
            spTokenModel.storeId,
            spTokenModel.executeUrl,
            amount,
            paymentId,
            customerName,
            customerAddress,
            customerPhone);
      } else {
        print("error from the server");
      }
    } catch (ex) {
      print(ex);
    }
  }

  void invockedPayment(
      String token,
      int storeId,
      String executeUrl,
      String amount,
      String paymentId,
      String customerName,
      String customerAddres,
      String customerPhone) async {
    var url = Uri.parse("https://sandbox.shurjopayment.com/api/secret-pay");
    try {
      var response = await http.post(
        url,
        body: json.encode({
          "prefix": "NOK",
          "token": token.toString(),
          "return_url": "https://www.sandbox.shurjopayment.com/response",
          "cancel_url": "https://www.sandbox.shurjopayment.com/response",
          "store_id": storeId.toString(),
          "amount": amount.toString(),
          "order_id": paymentId.toString(),
          "currency": "BDT",
          "customer_name": customerName.toString(),
          "customer_address": customerAddres.toString(),
          "customer_phone": customerPhone.toString(),
          "customer_city": "Dhaka",
          "customer_post_code": "1212",
          "client_ip": "102.101.1.1"
        }),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
      );
      // var jsonResponse = json.decode(response.body.toString());
      // print(jsonResponse);
      if (response.statusCode == 200) {
        SpCheckoutModel spTokenModel =
            spCheckoutModelFromJson(response.body.toString());
        // CheckoutSP(
        //   checkoutUrl: spTokenModel.checkoutUrl,
        // );
        print(spTokenModel.checkoutUrl);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => CheckoutSP(
                  checkoutUrl: spTokenModel.checkoutUrl,
                ))));
        /**Procced Payment within Time Range  */

      } else {
        setState(() {
          _isLoading = false;
        });
        Toast.show("Please Try Again !", context);
        print("error from the server");
      }
    } catch (ex) {
      print("FROM EXECUTE : " + ex.toString());
    }
  }

  void getPackages() async {
    var url = Uri.parse("https://adminapplication.com/fetch_package");
    try {
      var response = await http.post(
        url,
      );

      print(response);
      if (response.statusCode == 200) {
        PackageListModel _packageModel =
            packageListModelFromJson(response.body.toString());

        /**Procced Payment within Time Range  */

        setState(() {
          _packages = _packageModel.packages;
        });
      }
    } catch (ex) {
      print("FROM Packages Error : " + ex.toString());
    }
  }

  List<IconData> iconlist = [
    Icons.arrow_circle_down,
    Icons.music_video,
    Icons.add,
    Icons.stream,
  ];
  List<String> titleList = [
    'Download',
    'Ad free',
    'Create Playlist',
    'HD Streaming'
  ];
  List<String> subTitleList = [
    'Download and listen offline music',
    'Listen song and watch video without Ad',
    'Create Playlist of your choice',
    'Watch HD Videos and Music'
  ];
  List<Color> colorList = [
    Colors.blue,
    Colors.purple,
    Colors.green,
    Colors.yellow
  ];
}
