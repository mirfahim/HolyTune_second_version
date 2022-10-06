import 'package:HolyTune/providers/DashboardModel.dart';
import 'package:HolyTune/screens/VideosScreen.dart';
import 'package:HolyTune/screens/unityAds/unity_ads.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import '../utils/TextStyles.dart';
import '../i18n/strings.g.dart';
import '../models/Media.dart';
import '../providers/AppStateNotifier.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../providers/SearchModel.dart';
import '../widgets/MediaItemTile.dart';

class VideosScreen extends StatelessWidget {
  static String routeName = "/search";

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SearchModel()),
      ],
      child: SearchScreenBody(),
    );
  }
}

class SearchScreenBody extends StatefulWidget {
  SearchScreenBody();

  @override
  SearchScreenRouteState createState() => new SearchScreenRouteState();
}

class SearchScreenRouteState extends State<SearchScreenBody> {

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
  DashboardModel dashboardModel;
  BuildContext context;
  bool clicked = false;
  bool finishLoading = true;
  bool showClear = false;
  final TextEditingController inputController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAds();

  }

  @override
  void dispose() {
    super.dispose();
    inputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UnityAds.showVideoAd(
      placementId: "Rewarded_Android",
      onComplete: (placementId) {
        print('Video Ad $placementId completed');
        _loadAd(placementId);
      },
      onFailed: (placementId, error, message) {
        print('Video Ad $placementId failed: $error $message');_loadAd(placementId);
      },
      onStart: (placementId) => print('Video Ad $placementId started'),
      onClick: (placementId) => print('Video Ad $placementId click'),
      onSkipped: (placementId) {
        print('Video Ad $placementId skipped');
        _loadAd(placementId);
      },
    );
    this.context = context;
    List<Media> items = [];
    final appState = Provider.of<AppStateNotifier>(context);
    final searchModel = Provider.of<SearchModel>(context);
    items = searchModel.items;

    void _onLoading() async {
      searchModel.fetchMoreSearch();
    }

    void onItemClick(int indx) {}

    return new Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //bottomNavigationBar: CustomBottomNavBar(),
      body: clicked == false
          ? VidiosOptionalPage()
          : SmartRefresher(
              enablePullDown: false,
              enablePullUp: searchModel.items.length > 20 ? true : false,
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
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              controller: searchModel.refreshController,
              onLoading: _onLoading,
              child: buildContent(
                  context, searchModel, appState, items, onItemClick)),
    );
  }

  Widget buildContent(BuildContext context, SearchModel searchModel,
      AppStateNotifier appState, List<Media> items, Function onItemClick) {
    if (searchModel.isLoading) {
      return Align(
        child: Container(
          height: 150,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
              Container(height: 5),
              Text(
                t.performingsearch,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        alignment: Alignment.center,
      );
    } else if (searchModel.isError) {
      return Align(
        child: Container(
          width: 180,
          height: 100,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(t.nosearchresult,
                  style: TextStyles.caption(context)
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 15)),
              Container(height: 5),
              Text(t.nosearchresulthint,
                  textAlign: TextAlign.center,
                  style: TextStyles.medium(context).copyWith(fontSize: 13)),
            ],
          ),
        ),
        alignment: Alignment.center,
      );
    } else if (searchModel.isIdle) {
      return Align(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.search,
                color: Colors.grey[500],
                size: 80,
              ),
              Container(height: 5),
            ],
          ),
        ),
        alignment: Alignment.center,
      );
    } else {
      return ListView.builder(
        itemCount: items.length,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(3),
        itemBuilder: (BuildContext context, int index) {
          return ItemTile(
            mediaList: items,
            index: index,
            object: items[index],
          );
        },
      );
    }
  }
}
