import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:HolyTune/utils/TimUtil.dart';
import '../providers/AudioPlayerModel.dart';
import '../providers/MediaPlayerModel.dart';

class Player extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AudioPlayerModel audioPlayerModel = Provider.of<AudioPlayerModel>(context);
    return Column(
      children: _controllers(context, audioPlayerModel),
    );
  }

  Widget _timer(BuildContext context, AudioPlayerModel audioPlayerModel) {
    var style = new TextStyle(
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
          print("snapshot.data = " + snapshot.data.toString());
          print("backgroundAudioDurationSeconds = " +
              audioPlayerModel.backgroundAudioDurationSeconds.toString());
          print("seekSliderValue = " + seekSliderValue.toString());
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
        thumbShape: RoundSliderThumbShape(
            enabledThumbRadius: 07)),

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
            new Text(
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
        child: new Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: _timer(context, audioPlayerModel),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[


            IconButton(
              onPressed: () {
                audioPlayerModel.skipPrevious();
                Provider.of<MediaPlayerModel>(context, listen: false)
                    .setMediaLikesCommentsCount(audioPlayerModel.currentMedia);
              },
              icon: Icon(
                //Icons.skip_previous,
                Icons.fast_rewind,
                size: 25.0,
                color: Colors.white,
              ),
            ),
            ClipOval(
                child: Container(
              color: Theme.of(context).accentColor.withAlpha(30),
              width: 50.0,
              height: 50.0,
              child: IconButton(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                onPressed: () {
                  audioPlayerModel.onPressed();
                },
                icon: audioPlayerModel.icon(false),
              ),
            )),
            IconButton(
              onPressed: () {
                audioPlayerModel.skipNext();
                Provider.of<MediaPlayerModel>(context, listen: false)
                    .setMediaLikesCommentsCount(audioPlayerModel.currentMedia);
              },
              icon: Icon(
                //Icons.skip_next,
                Icons.fast_forward,
                size: 25.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      // Visibility(
      //   visible: !audioPlayerModel.showList,
      //   child: new Padding(
      //     padding: const EdgeInsets.symmetric(
      //       horizontal: 16.0,
      //     ),
      //     child: _timer(context, audioPlayerModel),
      //   ),
      // ),
    ];
  }
}
