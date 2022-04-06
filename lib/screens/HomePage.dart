import 'dart:convert';
import 'dart:io';
import 'package:HolyTune/widgets/sliderWidget.dart';
import 'package:http/http.dart' as http;
import 'package:HolyTune/database/SharedPreference.dart';
import 'package:HolyTune/widgets/CustomBottomBar.dart';
import 'package:HolyTune/widgets/Footer.dart';
import 'package:HolyTune/widgets/sliderImage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
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
import '../providers/DashboardModel.dart';
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
import '../screens/Dashboard.dart';
import '../screens/MediaScreen.dart';
import '../screens/AudioScreen.dart';
import '../screens/Downloader.dart';
import '../models/ScreenArguements.dart';
import '../screens/BookmarksScreen.dart';
import '../screens/PlaylistsScreen.dart';
import '../screens/SearchScreen.dart';
import '../widgets/Banneradmob.dart';

class HomePage extends StatefulWidget {
  bool login;
  HomePage({this.login});
  // HomePage({Key key}) : super(key: key,  );
  //static const routeName = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  int currentIndex = 0;

  void onDrawerItemClicked(int indx) {
    Navigator.pop(context);
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        currentIndex = indx;
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
    // _checkVersion();
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
  }

  var serverVersion;
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
      // print("deviceVersion " + status.localVersion);
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
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // appBar: PreferredSize(
        //    preferredSize: Size.fromHeight(60.0),
        //    child: Center(
        //      child: AppBar(
        //        elevation: 0,
        //        backgroundColor:MyColors.appColor,
        //
        //        // title: RichText(
        //        //   textAlign: TextAlign.start,
        //        //   text: TextSpan(
        //        //       text: 'Holy',
        //        //       style: TextStyles.caption(context).copyWith(
        //        //         fontSize: 20,
        //        //         fontWeight: FontWeight.w700,
        //        //         color: Color(0xffe46b10),
        //        //       ),
        //        //       children: [
        //        //         TextSpan(
        //        //           text: 'Tune',
        //        //           style: TextStyle(
        //        //               color: appState.isDarkModeOn
        //        //                   ? Colors.white
        //        //                   : Colors.black,
        //        //               fontSize: 20),
        //        //         ),
        //        //       ]),
        //        // ),
        //        actions: <Widget>[
        //          IconButton(
        //              icon: Icon(Icons.cloud_download),
        //              onPressed: (() {
        //                Navigator.pushNamed(context, Downloader.routeName,
        //                    arguments: ScreenArguements(
        //                      position: 0,
        //                      items: null,
        //                    ));
        //              })),
        //          IconButton(
        //              icon: Icon(Icons.search),
        //              onPressed: (() {
        //                Navigator.pushNamed(context, SearchScreen.routeName);
        //              }))
        //        ],
        //      ),
        //
        //    ),
        //  ),
        //  bottomNavigationBar: CustomBottomNavBar(
        //
        //
        //  ),
        body: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: <Widget>[
              Expanded(child: buildPageBody(currentIndex, userdata)),
              // Banneradmob(),
              MiniPlayer(),
            ],
          ),
        ),
        // drawer: SafeArea(
        //   child: Container(
        //     color: Theme.of(context).scaffoldBackgroundColor,
        //     width: 250,
        //     child: Drawer(
        //       key: scaffoldKey,
        //       child: SingleChildScrollView(
        //         child: Column(
        //           children: <Widget>[
        //             Container(
        //               height: 130,
        //               width: double.infinity,
        //               //padding: EdgeInsets.all(10),
        //               color: Theme.of(context).scaffoldBackgroundColor,
        //               child: Stack(
        //                 children: <Widget>[
        //                   Container(
        //                     height: double.infinity,
        //                     width: double.infinity,
        //                     child: Image.asset(
        //                       Img.get(""),
        //                       fit: BoxFit.fill,
        //                     ),
        //                   ),
        //                   Container(
        //                     //color: Colors.black38,
        //                     height: double.infinity,
        //                     width: double.infinity,
        //                   ),
        //                   Column(
        //                     children: <Widget>[
        //                       Container(
        //                         height: 30,
        //                       ),
        //                       CircleAvatar(
        //                         radius: 20,
        //                         backgroundColor: MyColors.accentDark,
        //                         child: Text(
        //                           userdata == null
        //                               ? t.guestuser.substring(0, 1)
        //                               : userdata.name.substring(0, 1),
        //                           style: TextStyles.headline(context)
        //                               .copyWith(color: Colors.white),
        //                         ),
        //                       ),
        //                       Container(height: 15),
        //                       SizedBox(
        //                         height: 30,
        //                         width: 130,
        //                         child: ElevatedButton(
        //                           child: Text( SharedPref.loginState != "false" ?
        //                              "login" : "logout" ,
        //                           //  userdata == null ? t.login : t.logout,
        //                             style: TextStyles.headline(context)
        //                                 .copyWith(
        //                                     color: Colors.white, fontSize: 14),
        //                           ),
        //                           style: ElevatedButton.styleFrom(
        //                             primary: MyColors.accent,
        //                           ),
        //                           //style: ButtonStyle(backgroundColor: MyColors.accent,),
        //
        //                           onPressed: () {
        //                             if (userdata != null) {
        //                               showLogoutAlert();
        //                             } else {
        //                               Navigator.pushNamed(context, LoginScreen.routeName);
        //                             }
        //                           },
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             Divider(),
        //             Container(
        //               height: 0,
        //             ),
        //             Container(
        //               height: 55,
        //               color: currentIndex == 0
        //                   ? Colors.black38
        //                   : (Theme.of(context).scaffoldBackgroundColor),
        //               child: ListTile(
        //                 title: Text(t.home,
        //                     style: TextStyles.subhead(context).copyWith(
        //                         fontSize: 15, fontWeight: FontWeight.bold)),
        //                 leading: Icon(LineAwesomeIcons.home, size: 25.0),
        //                 onTap: () {
        //                   onDrawerItemClicked(0);
        //                 },
        //               ),
        //             ),
        //             Container(
        //               height: 55,
        //               color: currentIndex == 1
        //                   ? Colors.black38
        //                   : (Theme.of(context).scaffoldBackgroundColor),
        //               child: ListTile(
        //                 title: Text(t.albums,
        //                     style: TextStyles.subhead(context).copyWith(
        //                         fontSize: 15, fontWeight: FontWeight.bold)),
        //                 leading: Icon(Icons.album, size: 25.0),
        //                 onTap: () {
        //                   onDrawerItemClicked(1);
        //                 },
        //               ),
        //             ),
        //             Container(
        //               height: 55,
        //               color: currentIndex == 2
        //                   ? Colors.black38
        //                   : (Theme.of(context).scaffoldBackgroundColor),
        //               child: ListTile(
        //                 title: Text(t.artists,
        //                     style: TextStyles.subhead(context).copyWith(
        //                         fontSize: 15, fontWeight: FontWeight.bold)),
        //                 leading: Icon(Icons.people, size: 25.0),
        //                 onTap: () {
        //                   onDrawerItemClicked(2);
        //                 },
        //               ),
        //             ),
        //             Container(
        //               height: 55,
        //               color: currentIndex == 3
        //                   ? Colors.black38
        //                   : (Theme.of(context).scaffoldBackgroundColor),
        //               child: ListTile(
        //                 title: Text(t.audiotracks,
        //                     style: TextStyles.subhead(context).copyWith(
        //                         fontSize: 15, fontWeight: FontWeight.bold)),
        //                 leading: Icon(LineAwesomeIcons.music, size: 25.0),
        //                 onTap: () {
        //                   onDrawerItemClicked(3);
        //                 },
        //               ),
        //             ),
        //             Container(
        //               height: 55,
        //               color: currentIndex == 4
        //                   ? Colors.black38
        //                   : (Theme.of(context).scaffoldBackgroundColor),
        //               child: ListTile(
        //                 title: Text(t.trendingaudios,
        //                     style: TextStyles.subhead(context).copyWith(
        //                         fontSize: 15, fontWeight: FontWeight.bold)),
        //                 leading: Icon(Icons.trending_up_outlined, size: 25.0),
        //                 onTap: () {
        //                   onDrawerItemClicked(4);
        //                 },
        //               ),
        //             ),
        //             Container(
        //               height: 55,
        //               color: currentIndex == 5
        //                   ? Colors.black38
        //                   : (Theme.of(context).scaffoldBackgroundColor),
        //               child: ListTile(
        //                 title: Text(t.moods,
        //                     style: TextStyles.subhead(context).copyWith(
        //                         fontSize: 15, fontWeight: FontWeight.bold)),
        //                 leading: Icon(Icons.emoji_emotions, size: 25.0),
        //                 onTap: () {
        //                   onDrawerItemClicked(5);
        //                 },
        //               ),
        //             ),
        //             Container(
        //               height: 55,
        //               color: currentIndex == 6
        //                   ? Colors.black38
        //                   : (Theme.of(context).scaffoldBackgroundColor),
        //               child: ListTile(
        //                 title: Text(t.playlist,
        //                     style: TextStyles.subhead(context).copyWith(
        //                         fontSize: 15, fontWeight: FontWeight.bold)),
        //                 leading: Icon(Icons.playlist_play, size: 25.0),
        //                 onTap: () {
        //                   onDrawerItemClicked(6);
        //                 },
        //               ),
        //             ),
        //             Container(
        //               height: 55,
        //               color: currentIndex == 7
        //                   ? Colors.black38
        //                   : (Theme.of(context).scaffoldBackgroundColor),
        //               child: ListTile(
        //                 title: Text(t.bookmarks,
        //                     style: TextStyles.subhead(context).copyWith(
        //                         fontSize: 15, fontWeight: FontWeight.bold)),
        //                 leading: Icon(LineAwesomeIcons.bookmark, size: 25.0),
        //                 onTap: () {
        //                   onDrawerItemClicked(7);
        //                 },
        //               ),
        //             ),
        //             Container(
        //               height: 55,
        //               color: currentIndex == 8
        //                   ? Colors.black38
        //                   : (Theme.of(context).scaffoldBackgroundColor),
        //               child: ListTile(
        //                 title: Text(t.settings,
        //                     style: TextStyles.subhead(context).copyWith(
        //                         //color: Colors.white,
        //                         fontSize: 15,
        //                         fontWeight: FontWeight.bold)),
        //                 leading: Icon(Icons.settings, size: 25.0),
        //                 onTap: () {
        //                   onDrawerItemClicked(8);
        //                 },
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }

  Widget buildPageBody(int currentIndex, Userdata userdata) {
    if (currentIndex == 0) {
      return ChangeNotifierProvider(
        create: (context) => DashboardModel(context, userdata),
        child:
            // ListView(
            //   children: [
            //     Container(
            //         height: 400,
            //         child: SliderPage()),

            DashboardScreen(),
        // ],

        //  ),
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
        create: (context) => new MediaScreensModel(userdata),
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
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
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
                  child: Icon(
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
}
