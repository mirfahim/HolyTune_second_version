import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:HolyTune/utils/TimUtil.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import '../providers/AudioPlayerModel.dart';
import '../providers/MediaPlayerModel.dart';
import '../screens/unityAds/unity_ads.dart';

class Player extends StatefulWidget {
  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {

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
    // TODO: implement initState
    super.initState();

    _loadAds();
  }
  @override
  Widget build(BuildContext context) {
    AudioPlayerModel audioPlayerModel = Provider.of<AudioPlayerModel>(context);
    return Column(
      children: _controllers(context, audioPlayerModel),
    );
  }

  Widget _timer(BuildContext context, AudioPlayerModel audioPlayerModel) {
    var style = TextStyle(
      color: Colors.white54,
      fontSize: 13,
    );
    return StreamBuilder(
      initialData: audioPlayerModel.backgroundAudioPositionSeconds,
      stream: audioPlayerModel.audioProgressStreams.stream.asBroadcastStream(),
      builder: (BuildContext context, snapshot) {
        double seekSliderValue = 0;
        if (snapshot != null || snapshot.data != null) {
          seekSliderValue = snapshot.data /
              audioPlayerModel.backgroundAudioDurationSeconds.floor();
          if (seekSliderValue.isNaN || seekSliderValue < 0) {
            seekSliderValue = 0;
          }
          if (seekSliderValue > 1) {
            seekSliderValue = 1;
          }
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              TimUtil.stringForSeconds(
                  (snapshot == null || snapshot.data == null)
                      ? 0.0
                      : snapshot.data),
              style: style,
            ),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 3,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 07),
                ),
                child: Slider(
                    activeColor: Colors.blue,
                    value: seekSliderValue,
                    onChangeEnd: (v) {
                      audioPlayerModel.onStartSeek();
                    },
                    onChanged: (double val) {
                      final double positionSeconds =
                          val * audioPlayerModel.backgroundAudioDurationSeconds;
                      audioPlayerModel.seekTo(positionSeconds);
                    }),
              ),
            ),
            Text(
              TimUtil.stringForSeconds(
                  audioPlayerModel.backgroundAudioDurationSeconds),
              style: style,
            ),
          ],
        );
      },
    );
  }

  List<Widget> _controllers(
      BuildContext context, AudioPlayerModel audioPlayerModel) {
    return [
      Visibility(
        visible: !audioPlayerModel.showList,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: _timer(context, audioPlayerModel),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
              onPressed: () {
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
                audioPlayerModel.skipPrevious();
                Provider.of<MediaPlayerModel>(context, listen: false)
                    .setMediaLikesCommentsCount(audioPlayerModel.currentMedia);
              },
              icon: Icon(
                Icons.fast_rewind,
                size: 25.0,
                color: Colors.white54,
              ),
            ),
            ClipOval(
              child: Container(
                color: Colors.blue,
                width: 50.0,
                height: 50.0,
                child: IconButton(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  onPressed: () {
                    audioPlayerModel.onPressed();
                  },
                  icon: audioPlayerModel.icon(false),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
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
                audioPlayerModel.skipNext();
                Provider.of<MediaPlayerModel>(context, listen: false)
                    .setMediaLikesCommentsCount(audioPlayerModel.currentMedia);
              },
              icon: Icon(
                Icons.fast_forward,
                size: 25.0,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    ];
  }
}
