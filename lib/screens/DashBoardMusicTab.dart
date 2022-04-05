import 'package:HolyTune/utils/my_colors.dart';
import 'package:HolyTune/widgets/sliderImage.dart';
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
import 'package:flutter_switch/flutter_switch.dart';
import 'package:shimmer/shimmer.dart';

class DashboardMusicTabScreen extends StatefulWidget {
  DashboardMusicTabScreen();

  @override
  DashboardScreenRouteState createState() => new DashboardScreenRouteState();
}

class DashboardScreenRouteState extends State<DashboardMusicTabScreen> {
  DashboardModel dashboardModel;
  bool isSubscribed = false;
  bool isToggled = false;

  onRetryClick() {
    dashboardModel.loadItems();
  }

  @override
  void initState() {
    //Provider.of<DashboardModel>(context, listen: false).fetchItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dashboardModel = Provider.of<DashboardModel>(context);
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
                    child:
                    Row(
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
                        ),
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
    } else
      return Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[


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



              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: MediaListView(dashboardModel.trendingAudios,
                    t.trendingaudios, t.trendingaudioshint),
              ),
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: MediaListView(dashboardModel.latestAudios, t.audiotracks,
                    t.newaudioshint),
              ),
              Consumer<PlaylistsModel>(
                builder: (context, playlistsModel, child) {
                  List<Playlists> playlistsList = playlistsModel.playlistsList;
                  if (playlistsList.length > 10) {
                    playlistsModel.playlistsList.sublist(0, 10);
                  }
                  return Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: PlaylistsListView(playlistsList),
                  );
                },
              ),
              Consumer<BookmarksModel>(
                builder: (context, bookmarksModel, child) {
                  List<Media> bookmarksList = bookmarksModel.bookmarksList;
                  if (bookmarksList.length > 10) {
                    bookmarksModel.bookmarksList.sublist(0, 10);
                  }
                  return Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: MediaListView(bookmarksList, t.bookmarksMedia, ""),
                  );
                },
              ),
            ],
          ),
        ),
      );
  }
}
