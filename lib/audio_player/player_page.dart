import 'package:HolyTune/utils/my_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../i18n/strings.g.dart';
import '../models/Userdata.dart';
import '../providers/AppStateNotifier.dart';
import '../providers/MediaPlayerModel.dart';
import '../models/Media.dart';
import '../widgets/MarqueeWidget.dart';
import '../utils/TextStyles.dart';
import '../providers/AudioPlayerModel.dart';
import '../widgets/ads_admob.dart';
import 'song_list_carousel.dart';
import 'package:provider/provider.dart';
import 'player_carousel.dart';
import '../widgets/MediaPopupMenu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayPage extends StatefulWidget {
  static const routeName = "/playerpage";

  PlayPage();

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> with TickerProviderStateMixin {
  AnimationController controllerPlayer;
  Animation<double> animationPlayer;
  final _commonTween = Tween<double>(begin: 0.0, end: 1.0);
  Userdata userdata;

  @override
  initState() {
    super.initState();
    userdata = Provider.of<AppStateNotifier>(context, listen: false).userdata;
    controllerPlayer = AnimationController(
        duration: const Duration(milliseconds: 15000), vsync: this);
    animationPlayer =
        CurvedAnimation(parent: controllerPlayer, curve: Curves.linear);
    animationPlayer.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controllerPlayer.repeat();
      } else if (status == AnimationStatus.dismissed) {
        controllerPlayer.forward();
      }
    });
  }

  @override
  void dispose() {
    controllerPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    AudioPlayerModel audioPlayerModel = Provider.of(context);
    if (audioPlayerModel.remoteAudioPlaying) {
      controllerPlayer.forward();
    } else {
      controllerPlayer.stop(canceled: false);
    }
    if (audioPlayerModel.currentMedia == null) {
      Navigator.of(context).pop();
    }
    return audioPlayerModel.currentMedia == null
        ? Container(
            color: Colors.black,
            child: Center(
              child: Text(
                t.cleanupresources,
                style: TextStyles.headline(context)
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          )
        : ChangeNotifierProvider(
            create: (context) =>
                MediaPlayerModel(userdata, audioPlayerModel.currentMedia),
            child: Scaffold(
              backgroundColor: MyColors.appColor,
              body: Stack(
                children: <Widget>[
                  _buildWidgetAlbumCoverBlur(mediaQuery, audioPlayerModel),
                  BuildPlayerBody(
                      userdata: userdata,
                      audioPlayerModel: audioPlayerModel,
                      commonTween: _commonTween,
                      controllerPlayer: controllerPlayer),
                ],
              ),
            ),
          );
  }

  Widget _buildWidgetAlbumCoverBlur(
      MediaQueryData mediaQuery, AudioPlayerModel audioPlayerModel) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.black, //audioPlayerModel.backgroundColor.withAlpha(250),
    );
  }
}

class BuildPlayerBody extends StatelessWidget {
  const BuildPlayerBody({
    Key key,
    @required this.audioPlayerModel,
    @required Tween<double> commonTween,
    @required this.controllerPlayer,
    @required this.userdata,
  })  : _commonTween = commonTween,
        super(key: key);

  final AudioPlayerModel audioPlayerModel;
  final Tween<double> _commonTween;
  final AnimationController controllerPlayer;
  final Userdata userdata;

  @override
  Widget build(BuildContext context) {
    // ads Implimentetion Start
    final BannerAd myBanner = BannerAd(
      adUnitId: 'ca-app-pub-2662237367678556/9607124603',
      size: AdSize(width: 468, height: 60),
      request: AdRequest(),
      listener: BannerAdListener(),
    );
    // ads Implimentetion End
    return Container(
      color: Color(0xFF2B2B2B),
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 25.0,
                      color: Colors.white,
                    ),
                    onPressed: () => {
                      Navigator.pop(context),
                    },
                  ),
                  SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: MarqueeWidget(
                      direction: Axis.horizontal,
                      child: Text(
                        audioPlayerModel.currentMedia.album,
                        maxLines: 1,
                        style: TextStyles.subhead(context)
                            .copyWith(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              !audioPlayerModel.showList
                  ? Column(
                      children: <Widget>[
                        SizedBox(height: 0),
                        // RotatePlayer(
                        //   animation: _commonTween.animate(controllerPlayer),
                        // ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.45,
                          color: Color(0xFF2B2B2B),
                          child: CachedNetworkImage(
                            imageUrl: audioPlayerModel.currentMedia.coverPhoto,
                            imageBuilder: (context, imageProvider) => Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 20,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                  //colorFilter:
                                  //   ColorFilter.mode(Colors.black87, BlendMode.darken),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFA8A8A8),
                                    blurRadius: 7,
                                    spreadRadius: 0,
                                    offset: Offset(0, 0),
                                  )
                                ],
                              ),
                            ),
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 20,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: AssetImage('assets/images/01.jpg'),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFA8A8A8),
                                    blurRadius: 7,
                                    spreadRadius: 0,
                                    offset: Offset(0, 0),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                          child: MarqueeWidget(
                            direction: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Text(
                                  audioPlayerModel.currentMedia.title,
                                  maxLines: 1,
                                  style: TextStyles.subhead(context).copyWith(
                                      fontSize: 18, color: Colors.white),
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Icon(
                                  Icons.file_download,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Text(
                            audioPlayerModel.currentMedia.artist,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            style: TextStyles.subhead(context).copyWith(
                              fontSize: 15,
                              color: Colors.white54,
                            ),
                          ),
                        ),
                        Player(),
                        MediaCommentsLikesContainer(
                          key: UniqueKey(),
                          context: context,
                          audioPlayerModel: audioPlayerModel,
                          currentMedia: audioPlayerModel.currentMedia,
                        ),
                        // Banneradmob(),
                      ],
                    )
                  : SongListCarousel(),
              // adContainer,
            ],
          ),
          BannerAdmob(bannerAd: myBanner),
        ],
      ),
    );
  }
}

class MediaCommentsLikesContainer extends StatefulWidget {
  const MediaCommentsLikesContainer({
    Key key,
    @required this.context,
    @required this.currentMedia,
    @required this.audioPlayerModel,
  }) : super(key: key);

  final BuildContext context;
  final Media currentMedia;
  final AudioPlayerModel audioPlayerModel;

  @override
  _MediaCommentsLikesContainerState createState() =>
      _MediaCommentsLikesContainerState();
}

class _MediaCommentsLikesContainerState
    extends State<MediaCommentsLikesContainer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MediaPlayerModel>(
      builder: (context, mediaPlayerModel, child) {
        return Container(
          height: 50,
          margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                width: 02,
              ),
              InkWell(
                onTap: () {
                  mediaPlayerModel
                      .likePost(mediaPlayerModel.isLiked ? "unlike" : "like");
                },
                child: Row(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 6),
                    child: FaIcon(FontAwesomeIcons.thumbsUp,
                        size: 26,
                        color: mediaPlayerModel.isLiked
                            ? Colors.pink
                            : Colors.white),
                  ),
                  mediaPlayerModel.likesCount == 0
                      ? Container()
                      : Text(mediaPlayerModel.likesCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                ]),
              ),
              SizedBox(
                width: 02,
              ),
              InkWell(
                onTap: () {
                  mediaPlayerModel.navigatetoCommentsScreen(context);
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.insert_comment, size: 26, color: Colors.white),
                    mediaPlayerModel.commentsCount == 0
                        ? Container()
                        : Text(mediaPlayerModel.commentsCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                  ],
                ),
              ),
              SizedBox(
                width: 02,
              ),
              IconButton(
                onPressed: () {
                  widget.audioPlayerModel.shufflePlaylist();
                  Provider.of<MediaPlayerModel>(context, listen: false)
                      .setMediaLikesCommentsCount(
                          widget.audioPlayerModel.currentMedia);
                },
                icon: Icon(
                  Icons.shuffle,
                  size: 26.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 02,
              ),
              IconButton(
                onPressed: () => null, //widget.audioPlayerModel
                //  .setShowList(!widget.audioPlayerModel.showList),
                icon: Icon(
                  Icons.playlist_play,
                  size: 27.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 02,
              ),
              IconButton(
                onPressed: () => widget.audioPlayerModel.changeRepeat(),
                icon: widget.audioPlayerModel.isRepeat == true
                    ? Icon(
                        Icons.repeat_one,
                        size: 26.0,
                        color: Colors.white,
                      )
                    : Icon(
                        Icons.repeat,
                        size: 26.0,
                        color: Colors.white,
                      ),
              ),
              MediaPopupMenu(widget.currentMedia),
            ],
          ),
        );
      },
    );
  }
}
