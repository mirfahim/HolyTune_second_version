import 'package:HolyTune/i18n/strings.g.dart';
import 'package:HolyTune/models/Media.dart';
import 'package:HolyTune/providers/BookmarksModel.dart';
import 'package:HolyTune/providers/DashboardModel.dart';
import 'package:HolyTune/utils/TextStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:shimmer/shimmer.dart';

import '../AlbumsListView.dart';
import '../ArtistsListView.dart';
import '../HomeSlider.dart';
import '../MediaListView.dart';
import '../NoitemScreen.dart';

class SearchDashboardScreen extends StatefulWidget {
  SearchDashboardScreen();

  @override
  DashboardScreenRouteState createState() => new DashboardScreenRouteState();
}

class DashboardScreenRouteState extends State<SearchDashboardScreen> {
  DashboardModel dashboardModel;
  bool isSubscribed = false;

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator()
           /* Expanded(
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
            ),*/
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
                    t.trending, t.trendingaudioshint),
              ),
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: MediaListView(dashboardModel.trendingAudios,
                    t.trending, t.trendingvideoshint),
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
                    child: MediaListView(bookmarksList, t.history, ""),
                  );
                },
              ),
            ],
          ),
        ),
      );
  }
}
