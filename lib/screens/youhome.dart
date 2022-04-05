import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:HolyTune/service/videolist.dart';
import '../models/chanelinfo.dart';
import '../service/videolist.dart';
import '../service/videoplayer.dart';
import '../widgets/service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.videoItem});
  final VideoItem videoItem;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ChannelInfo _channelInfo;
  VideosList _videosList;
  Item _item;
  bool _loading;
  String _playListId;
  String _nextPageToken;
  ScrollController _scrollController;

  YoutubePlayerController _controller;
  bool _isPlayerReady;
  // final VideoItem videoItem;

  @override
  void initState() {
    super.initState();
    _loading = true;
    _nextPageToken = '';
    _scrollController = ScrollController();
    _videosList = VideosList();
    _videosList.videos = List();
    _getChannelInfo();

    _isPlayerReady = false;
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoItem.video.resourceId.videoId,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    )..addListener(_listener);
  }

  void _listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      //
    }
  }

  // @override
  // void deactivate() {
  //   _controller.pause();
  //   super.deactivate();
  // }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _loading = true;
  //   _nextPageToken = '';
  //   _scrollController = ScrollController();
  //   _videosList = VideosList();
  //   _videosList.videos = List();
  //   _getChannelInfo();
  // }

  _getChannelInfo() async {
    _channelInfo = await Services.getChannelInfo();
    _item = _channelInfo.items[0];
    _playListId = _item.contentDetails.relatedPlaylists.uploads;
    print('_playListId $_playListId');
    await _loadVideos();
    setState(() {
      _loading = false;
    });
  }

  _loadVideos() async {
    VideosList tempVideosList = await Services.getVideosList(
      playListId: _playListId,
      pageToken: _nextPageToken,
    );
    _nextPageToken = tempVideosList.nextPageToken;
    _videosList.videos.addAll(tempVideosList.videos);
    print('videos: ${_videosList.videos.length}');
    print('_nextPageToken $_nextPageToken');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.videoItem.video.title),
      ),
      body: Column(
        children: [
          _buildInfoView(),
          // Container(
          //   child:
          // ),
          Expanded(
            child: NotificationListener<ScrollEndNotification>(
              onNotification: (ScrollNotification notification) {
                if (_videosList.videos.length >=
                    int.parse(_item.statistics.videoCount)) {
                  return true;
                }
                if (notification.metrics.pixels ==
                    notification.metrics.maxScrollExtent) {
                  _loadVideos();
                }
                return true;
              },
              child: ListView.builder(
                // shrinkWrap: true,
                controller: _scrollController,
                itemCount: _videosList.videos.length,
                itemBuilder: (context, index) {
                  VideoItem videoItem = _videosList.videos[index];
                  return InkWell(
                    onTap: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return YoutubePlayer(
                            //videoItem: videoItem,
                            );
                      }));
                    },
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: videoItem
                                .video.thumbnails.thumbnailsDefault.url,
                          ),
                          SizedBox(width: 20),
                          Flexible(child: Text(videoItem.video.title)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildInfoView() {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      onReady: () {
        print('Player is ready.');
        _isPlayerReady = true;
      },
    );
  }
}
