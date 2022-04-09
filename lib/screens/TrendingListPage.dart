import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/Media.dart';
import '../i18n/strings.g.dart';
import '../providers/MediaScreensModel.dart';
import '../screens/NoitemScreen.dart';
import '../widgets/MediaItemTile.dart';
import '../models/Userdata.dart';
import '../providers/AppStateNotifier.dart';

class TrendingListPage extends StatefulWidget {
  TrendingListPage();

  @override
  TrendingListPageRouteState createState() => TrendingListPageRouteState();
}

class TrendingListPageRouteState extends State<TrendingListPage> {
  @override
  Widget build(BuildContext context) {
    AppStateNotifier appState = Provider.of<AppStateNotifier>(context);
    Userdata userdata = appState.userdata;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xFF111111),
        title: Text(t.hotandtrending),
      ),
      body: ChangeNotifierProvider(
        create: (context) => MediaScreensModel(userdata),
        child: MediaScreen(t.hotandtrending),
      ),
    );
  }
}

class MediaScreen extends StatefulWidget {
  MediaScreen(this.title);

  final String title;

  @override
  MediaScreenRouteState createState() => MediaScreenRouteState();
}

class MediaScreenRouteState extends State<MediaScreen> {
  MediaScreensModel mediaScreensModel;
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
      Provider.of<MediaScreensModel>(context, listen: false).loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    mediaScreensModel = Provider.of<MediaScreensModel>(context);
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
            body = CircularProgressIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text(t.loadfailedretry);
          } else if (mode == LoadStatus.canLoading) {
            body = Text(t.releaseloadmore);
          } else {
            body = Text(t.nomoredata);
          }
          return SizedBox(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: mediaScreensModel.refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: (mediaScreensModel.isError == true && items.isEmpty)
          ? NoitemScreen(
              title: t.oops, message: t.dataloaderror, onClick: _onRefresh)
          : ListView.builder(
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
    );
  }
}
