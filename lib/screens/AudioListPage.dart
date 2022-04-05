import 'package:HolyTune/utils/my_colors.dart';
import 'package:HolyTune/widgets/Banneradmob.dart';

import '../models/Userdata.dart';
import '../providers/AppStateNotifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/Media.dart';
import '../i18n/strings.g.dart';
import '../providers/AudioScreensModel.dart';
import '../screens/NoitemScreen.dart';
import '../widgets/MediaItemTile.dart';

class AudioListPage extends StatefulWidget {
  AudioListPage();

  @override
  TrendingListPageRouteState createState() => new TrendingListPageRouteState();
}

class TrendingListPageRouteState extends State<AudioListPage> {
  AppStateNotifier appState;

  @override
  Widget build(BuildContext context) {

    AppStateNotifier appState = Provider.of<AppStateNotifier>(context);
    Userdata userdata = appState.userdata;
    return new Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: appState.isDarkModeOn != true ? MyColors.softBlueColor : Colors.black54,

        title: new Text(t.audiotracks),
      ),
      body: ChangeNotifierProvider(
        create: (context) => AudioScreensModel(userdata),
        child: AudioScreen(),
      ),
    );
  }
}

class AudioScreen extends StatefulWidget {
  AudioScreen();

  @override
  MediaScreenRouteState createState() => new MediaScreenRouteState();
}

class MediaScreenRouteState extends State<AudioScreen> {
  AppStateNotifier appState;
  AudioScreensModel mediaScreensModel;
  List<Media> items;

  void _onRefresh() async {
    mediaScreensModel.loadItems();
  }

  void _onLoading() async {
    mediaScreensModel.loadMoreItems();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<AudioScreensModel>(context, listen: false).loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    mediaScreensModel = Provider.of<AudioScreensModel>(context);
    items = mediaScreensModel.mediaList;

    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text(t.pulluploadmore);
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text(t.loadfailedretry);
          } else if (mode == LoadStatus.canLoading) {
            body = Text(t.releaseloadmore);
          } else {
            body = Text(t.nomoredata);
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: mediaScreensModel.refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: (mediaScreensModel.isError == true && items.length == 0)
          ? NoitemScreen(
              title: t.oops, message: t.dataloaderror, onClick: _onRefresh)
          :
              ListView(
                children:[
                  ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: items.length + 1,
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.all(3),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Container();
                      } else {
                        int _indx = index - 1;
                        return ItemTile(
                          mediaList: items,
                          index: _indx,
                          object: items[_indx],
                        );
                      }
                    },
                  ),

                       Banneradmob(),
                ]
              ),

    );
  }
}
