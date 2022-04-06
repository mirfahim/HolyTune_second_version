import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as h;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LiveEventController extends ChangeNotifier {
  YoutubePlayerController ycontroller;
  String videoTitle = "Olama Tolaba";
  String videoArtist = 'Kalarab Sommilito Gojol';
  String videoUrl = "https://www.youtube.com/embed/f5c1UhQdmPU";

  List liveList = [];

  LiveEventController() {
    getLivedata();
    playVideo(null);
  }

  playVideo(String vUrl) async {
    String url = "https://adminapplication.com/fetch_live";
    Uri uri = Uri.parse(url);
    var res = await h.get(uri);
    if (vUrl == null && res.statusCode == 200) {
      var frs = jsonDecode(res.body);
      ycontroller = YoutubePlayerController(
        initialVideoId:
            YoutubePlayer.convertUrlToId(frs['lives'][0]['url']).toString(),
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          disableDragSeek: false,
          loop: false,
          isLive: true,
          forceHD: false,
        ),
      );
      notifyListeners();
    } else {
      ycontroller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(vUrl).toString(),
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
        ),
      );
    }
  }

  void getLivedata() async {
    String url = "https://adminapplication.com/fetch_upcominglive";
    Uri uri = Uri.parse(url);
    var res = await h.get(uri);
    if (res.statusCode == 200) {
      var frs = jsonDecode(res.body);
      liveList = frs['upcominglives'];
      notifyListeners();
    }
  }
}
