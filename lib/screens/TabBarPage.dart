import 'package:HolyTune/providers/AppStateNotifier.dart';
import 'package:HolyTune/screens/HomePage.dart';
import 'package:HolyTune/screens/SearchScreen.dart';
import 'package:HolyTune/screens/liveEvents.dart';

import 'package:HolyTune/screens/musicPageTab.dart';
import 'package:HolyTune/screens/unityAds/unity_ads.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import 'youtubevideo/listViewPage.dart';

class MyTabHomePage extends StatefulWidget {
  static const routeName = "/home";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyTabHomePage> {
  int selectedIndex = 0;
  AppStateNotifier appManager;
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
    super.initState();
    _loadAds();
  }
  @override
  Widget build(BuildContext context) {
    appManager = Provider.of<AppStateNotifier>(context);
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              color: appManager.isDarkModeOn == true
                  ? Color(0xFF303030)
                  : Color(0xFF303030)),
          height: 60,
          child: TabBar(
            indicatorPadding: EdgeInsets.all(10),
            onTap: (index) {
              print("MY__TAB__INDEX__$selectedIndex");
              setState(() {
                // UnityAds.showVideoAd(
                //   placementId: "Rewarded_Android",
                //   onComplete: (placementId) {
                //     print('Video Ad $placementId completed');
                //     _loadAd(placementId);
                //   },
                //   onFailed: (placementId, error, message) {
                //     print('Video Ad $placementId failed: $error $message');_loadAd(placementId);
                //   },
                //   onStart: (placementId) => print('Video Ad $placementId started'),
                //   onClick: (placementId) => print('Video Ad $placementId click'),
                //   onSkipped: (placementId) {
                //     print('Video Ad $placementId skipped');
                //     _loadAd(placementId);
                //   },
                // );
                selectedIndex = index;
              });
            },
            indicatorColor: Colors.transparent,
            //  labelColor: Color.fromARGB(255, 59, 50, 50),
            labelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 8, 3, 3),
            ),
            tabs: [
              selectedIndex == 0
                  ? Tab(
                      icon: Container(
                        padding: EdgeInsets.only(top: 8),
                        width: MediaQuery.of(context).size.width * 0.05,
                        child: Image.asset(
                          'assets/icon/homw.png',
                          color: Colors.blue,
                        ),
                      ),
                      iconMargin: EdgeInsets.only(bottom: 2),
                      text: "Home",
                      //  color: Colors.blue
                    )
                  : Tab(
                      icon: Container(
                        padding: EdgeInsets.only(top: 8),
                        width: MediaQuery.of(context).size.width * 0.05,
                        child: Image.asset(
                          'assets/icon/homw.png',
                          color: Colors.grey,
                        ),
                      ),
                      iconMargin: EdgeInsets.only(bottom: 5),
                      text: "Home",
                    ),
              selectedIndex == 1
                  ? Tab(
                      icon: Container(
                        padding: EdgeInsets.only(top: 8),
                        width: MediaQuery.of(context).size.width * 0.05,
                        child: Image.asset(
                          'assets/icon/mus.png',
                          color: Colors.blue,
                        ),
                      ),
                      iconMargin: EdgeInsets.only(bottom: 2),
                      text: "Music")
                  : Tab(
                      icon: Container(
                        padding: EdgeInsets.only(top: 8),
                        width: MediaQuery.of(context).size.width * 0.05,
                        child: Image.asset(
                          'assets/icon/mus.png',
                          color: Colors.grey,
                        ),
                      ),
                      iconMargin: EdgeInsets.only(bottom: 5),
                      text: "Music"),
              selectedIndex == 2
                  ? Tab(
                      icon: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.07,
                        child: Image.asset(
                          'assets/icon/liv.png',
                          color: Colors.blue,
                        ),
                      ),
                      iconMargin: EdgeInsets.only(bottom: 2),
                      text: "Live")
                  : Tab(
                      icon: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.07,
                        child: Image.asset(
                          'assets/icon/liv.png',
                          color: Colors.grey,
                        ),
                      ),
                      iconMargin: EdgeInsets.only(bottom: 5),
                      text: "Live"),
              selectedIndex == 3
                  ? Tab(
                      icon: Container(
                        padding: EdgeInsets.only(top: 8),
                        width: MediaQuery.of(context).size.width * 0.05,
                        child: Image.asset(
                          'assets/icon/vid.png',
                          color: Colors.blue,
                        ),
                      ),
                      iconMargin: EdgeInsets.only(bottom: 2),
                      text: "Video")
                  : Tab(
                      icon: Container(
                        padding: EdgeInsets.only(top: 8),
                        width: MediaQuery.of(context).size.width * 0.05,
                        child: Image.asset(
                          'assets/icon/vid.png',
                          color: Colors.grey,
                        ),
                      ),
                      iconMargin: EdgeInsets.only(bottom: 5),
                      text: "Video"),
              selectedIndex == 4
                  ? Tab(
                      icon: Container(
                        padding: EdgeInsets.only(top: 8),
                        width: MediaQuery.of(context).size.width * 0.05,
                        child: Image.asset(
                          'assets/icon/serr.png',
                          color: Colors.blue,
                        ),
                      ),
                      iconMargin: EdgeInsets.only(bottom: 2),
                      text: "Search")
                  : Tab(
                      icon: Container(
                        padding: EdgeInsets.only(top: 8),
                        width: MediaQuery.of(context).size.width * 0.05,
                        child: Image.asset(
                          'assets/icon/serr.png',
                          color: Colors.grey,
                        ),
                      ),
                      iconMargin: EdgeInsets.only(bottom: 5),
                      text: "Search"),
              // selectedIndex == 5
              //     ? Tab(
              //         icon: Padding(
              //           padding: const EdgeInsets.only(top: 8),
              //           child: Image.asset(
              //             'assets/icon/serr.png',
              //             color: Colors.blue,
              //           ),
              //         ),
              //         iconMargin: EdgeInsets.only(bottom: 5),
              //         text: "Search")
              //     : Tab(
              //         icon: Padding(
              //           padding: const EdgeInsets.only(top: 8),
              //           child: Image.asset(
              //             'assets/icon/serr.png',
              //           ),
              //         ),
              //         iconMargin: EdgeInsets.only(bottom: 5),
              //         text: "Search"),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            HomePage(),
            MusicTabPage(),
            LivePage(),
            ListViewPage(),
            SearchScreen(),
            // apiintre(),
          ],
        ),
      ),
    );
  }
}
