import 'package:HolyTune/database/SharedPreference.dart';
import 'package:HolyTune/providers/AppStateNotifier.dart';
import 'package:HolyTune/providers/SliderImageProvider.dart';
import 'package:HolyTune/screens/BookMarkWidgetDash.dart';
import 'package:HolyTune/utils/my_colors.dart';
import 'package:HolyTune/widgets/Banneradmob.dart';
import 'package:HolyTune/widgets/sliderImage.dart';
import 'package:HolyTune/widgets/sliderWidget.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../screens/MoodsListView.dart';
import '../screens/ArtistsListView.dart';
import '../screens/AlbumsListView.dart';
import '../providers/DashboardModel.dart';
import '../providers/BookmarksModel.dart';
import '../providers/PlaylistsModel.dart';
import '../screens/HomeSlider.dart';
import '../utils/TextStyles.dart';
import '../screens/MediaListView.dart';
import '../screens/PlaylistsListView.dart';
import '../i18n/strings.g.dart';
import '../screens/NoitemScreen.dart';
import '../models/Media.dart';
import '../models/Playlists.dart';
//import 'package:flutter_switch/flutter_switch.dart';
import 'package:shimmer/shimmer.dart';
//import 'package:facebook_audience_network/facebook_audience_network.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen();
  @override
  DashboardScreenRouteState createState() => new DashboardScreenRouteState();
}

class DashboardScreenRouteState extends State<DashboardScreen> {
  AppStateNotifier appManager;
  SliderImageProvider imageProvider;
  DashboardModel dashboardModel;
  bool isSubscribed = false;
  bool isToggled = false;
  onRetryClick() {
    dashboardModel.loadItems();
  }

  Widget _currentAd = SizedBox(
    height: 0,
    width: 0,
  );

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _currentAd = FacebookBannerAd(
  //     placementId:'IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617',
  //     bannerSize: BannerSize.STANDARD,
  //     listener: (result, value) {
  //       switch (result) {
  //         case BannerAdResult.ERROR:
  //           print('Error: $value');
  //           break;
  //         case BannerAdResult.LOADED:
  //           print('Load: $value');
  //           break;
  //         case BannerAdResult.CLICKED:
  //           print('Clicked: $value');
  //           break;
  //         case BannerAdResult.LOGGING_IMPRESSION:
  //           print('Loging inm: $value');
  //           break;
  //       }
  //     },
  //   );
  //   FacebookAudienceNetwork.init(
  //       testingId: "37b1da9d-b48c-4103-a393-2e095e734bd6", //optional
  //      // iOSAdvertiserTrackingEnabled: false //default false
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    appManager = Provider.of<AppStateNotifier>(context);
    dashboardModel = Provider.of<DashboardModel>(context);
    imageProvider = Provider.of<SliderImageProvider>(context);
    if (imageProvider.imageList.length == 0) {
      imageProvider.getSliderImages();
    }
    isSubscribed = true;
    if (dashboardModel.isLoading) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Shimmer.fromColors(
                baseColor: Colors.black26,
                highlightColor: Colors.black38,
                enabled: true,
                child: ListView.builder(
                  itemBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48.0,
                          height: 48.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: 40.0,
                                height: 8.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  itemCount: 12,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (dashboardModel.isError) {
      return NoitemScreen(
          title: t.oops, message: t.dataloaderror, onClick: onRetryClick);
    } else {
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: MyColors.appColor,
              width: MediaQuery.of(context).size.width,
              height: 570,
              child: CarouselWithIndicatorDemo(),
            ),

            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      "Hi ${SharedPref.profileName}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue),
                    ),
                    subtitle: Text(
                      "Welcome, Enjoy Holy Tune Islamic Music",
                      style: appManager.isDarkModeOn == false
                          ? TextStyle(
                              fontSize: 13,
                              color: Color.fromARGB(137, 182, 177, 177))
                          : TextStyle(fontSize: 13, color: Colors.white54),
                    ),
                    // trailing: FlutterSwitch(
                    //   height: 20.0,
                    //   width: 40.0,
                    //   padding: 4.0,
                    //   toggleSize: 15.0,
                    //   borderRadius: 10.0,
                    //   activeColor: Colors.blue,
                    //   value: appManager.isDarkModeOn,
                    //   onToggle: (value) {
                    //    // appManager.setAppTheme(value);
                    //   },
                    // ),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: ArtistsListView(dashboardModel.artists),
            ),

            // Container(
            //   color: Colors.transparent,
            //   height: 100,
            //   child: _currentAd,
            // ),

            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: MediaListView(
                  dashboardModel.latestAudios, t.audiotracks, t.newaudioshint),
            ),
            SizedBox(
              height: 05,
            ),
            // Container(
            //   color: Colors.transparent,
            //  // height: 100,
            //   child: _currentAd
            // ),

            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: MediaListView(dashboardModel.trendingAudios,
                  t.trendingaudios, t.trendingaudioshint),
            ),

            // Container(
            //   color: Theme.of(context).scaffoldBackgroundColor,
            //   padding: EdgeInsets.fromLTRB(0,0,0,0),
            //   width: double.infinity,
            //   child: Wrap(
            //     spacing: 6.0,
            //     runSpacing: 6.0,
            //     children: dashboardModel.chipsWidgets,
            //   ),
            // ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: AlbumsListView(dashboardModel.albums),
            ),
            // Container(
            //   color: Colors.transparent,
            //   height: 100,
            //   child: _currentAd
            // ),

            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: double.infinity,
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.fromLTRB(15, 20, 10, 10),
                child: Text(
                  t.suggestedforyou,
                  style: TextStyles.headline(context).copyWith(
                    fontWeight: FontWeight.bold,
                    //fontFamily: "serif",
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            HomeSlider(dashboardModel.sliderMedias),

            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: MoodsListView(dashboardModel.moods),
            ),

            Banneradmob(),
            SizedBox(
              height: 20,
            ),
            // BookmarksScreenDash(),
            Consumer<BookmarksModel>(
              builder: (context, bookmarksModel, child) {
                List<Media> bookmarksList = bookmarksModel.bookmarksList;
                if (bookmarksList.length > 10) {
                  bookmarksModel.bookmarksList.sublist(0, 10);
                }
                return Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: MediaListView(bookmarksList, t.bookmarksMedia, ""),
                );
              },
            ),

            Consumer<PlaylistsModel>(
              builder: (context, playlistsModel, child) {
                List<Playlists> playlistsList = playlistsModel.playlistsList;
                if (playlistsList.length > 10) {
                  playlistsModel.playlistsList.sublist(0, 10);
                }
                return Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: PlaylistsListView(playlistsList),
                );
              },
            ),
          ],
        ),
      );
    }
  }
}
