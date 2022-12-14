import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../widgets/ads_admob.dart';
import '../unityAds/unity_ads.dart';
import 'getData.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({Key key}) : super(key: key);
  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
// late
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
  YoutubePlayerController _controller;
  String videoTitle = "Olama Tolaba | ওলামা তলাবা";
  String videoArtist = 'Kalarab Sommilito Gojol';
  String videoUrl = "https://www.youtube.com/embed/f5c1UhQdmPU";

  @override
  void initState() {
    _loadAds();
    print(
        "------------------------------List View Page Ad Section------------------------------");
    interstitialingAd();
    print(
        "------------------------------List View Page Ad Section------------------------------");
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrl).toString(),
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: true,
      ),
    );
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
  }

  void setUrl(String url) {
    setState(() {
      videoUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    // context.read<getData>().getListData();
    return ChangeNotifierProvider<GetData>(
      create: (context) => GetData(),
      child: Scaffold(
          body: Column(
        mainAxisSize: MainAxisSize.min, //test
        children: [
          YoutubePlayer(
            controller: _controller,
            liveUIColor: Colors.amber,
            aspectRatio: 16 / 9,
          ),
          Container(
              height: 70,
              width: 500,
              child: Padding(
                padding: EdgeInsets.only(top: 15),
                child: Column(
                  children: [
                    Flexible(
                      child: Text(
                        videoTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFBBBBBB),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        videoArtist,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF6E6E6E),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Text("$artist")
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0xFF1F1F1F),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              )),
          SizedBox(
            height: 10,
          ),
          UnityBannerAd(
            placementId: "Banner_Android",
            onLoad: (placementId) => print('Banner loaded: $placementId'),
            onClick: (placementId) => print('Banner clicked: $placementId'),
            onFailed: (placementId, error, message) =>
                print('Banner Ad $placementId failed: $error $message'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "Popular Islamic Videos",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Icon(Icons.widgets_outlined),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: Consumer<GetData>(
              builder: (context, yGetData, child) {
                // print(yGetData.data.length);
                // return Text("dgfgfd");
                return yGetData.data.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        shrinkWrap: true,
                        // physics: BouncingScrollPhysics(),
                        itemCount: yGetData.data.length,
                        itemBuilder: (BuildContext context, index) {
                          return ListTile(
                            leading: Image.network(
                              yGetData.data[index].thumbnail.toString(),
                            ),
                            title: Text(
                              yGetData.data[index].title,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFBBBBBB),
                              ),
                            ),
                            subtitle: Text(
                              yGetData.data[index].artist,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6E6E6E),
                              ),
                            ),
                            trailing: Icon(Icons.more_vert_outlined),
                            onTap: () {
                              _controller.load(YoutubePlayer.convertUrlToId(
                                      yGetData.data[index].url)
                                  .toString());
                              setState(() {
                                videoUrl = yGetData.data[index].url.toString();
                                videoTitle =
                                    yGetData.data[index].title.toString();
                                videoArtist = yGetData.data[index].artist;
                              });
                              print(videoUrl);
                            },
                          );
                        },
                      );
              },
            ),
          ),
        ],
      )),
    );
  }

  // Widget getListView() {
  //   // context.read<getData>().getListData();
  //   return ;
  // }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 0));
    await context.read<GetData>().getListData();
    setState(() {});
  }
}
