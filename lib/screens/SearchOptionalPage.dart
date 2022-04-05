import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
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
import 'Search/SearchDashboard.dart';

class SearchOptionalPage extends StatefulWidget {
  SearchOptionalPage({Key key}) : super(key: key);
  static const routeName = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<SearchOptionalPage> {


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



  openBrowserTab(String url) async {
    await FlutterWebBrowser.openWebPage(
        url: url, androidToolbarColor: MyColors.primary);
  }

  @override
  void initState() {
    super.initState();
    _checkVersion();
  }

  void _checkVersion() async {
    final newVersion = NewVersion(
      androidId: "com.aapbd.holytune",
    );
    final status = await newVersion.getVersionStatus();
    newVersion.showUpdateDialog(
        context: context,
        versionStatus: status);

    print("deviceVersion " + status.localVersion);
    print("deviceVersion " + status.storeVersion);

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
            builder: (context) => new AlertDialog(
              title: new Text(t.quitapp),
              content: new Text(t.quitappaudiowarning),
              actions: <Widget>[
                new TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text(t.cancel),
                ),
                new TextButton(
                  onPressed: () {
                    Provider.of<AudioPlayerModel>(context, listen: false)
                        .cleanUpResources();
                    Navigator.of(context).pop(true);
                  },
                  child: new Text(t.ok),
                ),
              ],
            ),
          )) ??
              false;
        } else {
          return (await showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text(t.quitapp),
              content: new Text(t.quitappwarning),
              actions: <Widget>[
                new TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text(t.cancel),
                ),
                new TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: new Text(t.ok),
                ),
              ],
            ),
          )) ??
              false;
        }
      },
      child: Scaffold(

        body: Column(
          children: <Widget>[
            Expanded(child: buildPageBody(currentIndex, userdata)),
            MiniPlayer(),
           // Banneradmob(),
          ],
        ),

      ),
    );
  }

  Widget buildPageBody(int currentIndex, Userdata userdata) {
    if (currentIndex == 0) {
      return ChangeNotifierProvider(
        create: (context) => DashboardModel(context, userdata),
        child: SearchDashboardScreen(),
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
