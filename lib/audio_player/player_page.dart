import 'package:HolyTune/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'player_anim.dart';
import '../i18n/strings.g.dart';
import '../models/Userdata.dart';
import '../providers/AppStateNotifier.dart';
import '../providers/MediaPlayerModel.dart';
import '../models/Media.dart';
import '../widgets/MarqueeWidget.dart';
import '../utils/TextStyles.dart';
import '../providers/AudioPlayerModel.dart';
import 'song_list_carousel.dart';
import 'package:provider/provider.dart';
import 'player_carousel.dart';
import '../widgets/MediaPopupMenu.dart';
import '../widgets/Banneradmob.dart';
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
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);
  Userdata userdata;

  @override
  initState() {
    super.initState();
    userdata = Provider.of<AppStateNotifier>(context, listen: false).userdata;
    controllerPlayer = new AnimationController(
        duration: const Duration(milliseconds: 15000), vsync: this);
    animationPlayer =
        new CurvedAnimation(parent: controllerPlayer, curve: Curves.linear);
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
      color:Colors.black, //audioPlayerModel.backgroundColor.withAlpha(250),
    );
    /*Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.rectangle,
        image: DecorationImage(
          image: NetworkImage(audioPlayerModel.currentMedia.coverPhoto),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10.0,
          sigmaY: 10.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.0),
          ),
        ),
      ),
    );*/
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
    return Container(
      color: Colors.transparent,
      child: ListView(
        children: <Widget>[
          Container(
            child: Column(
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
                    SizedBox(width: 20,),
                    Container(
                      child: Padding(
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
                      ),
                    )
                  ],
                ),
                !audioPlayerModel.showList
                    ? Column(
                        children: <Widget>[
                          SizedBox(height: 0),
                          RotatePlayer(
                              animation:
                                  _commonTween.animate(controllerPlayer)),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.03),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                            child: MarqueeWidget(
                              direction: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [


                              Icon(Icons.favorite_border, color:Colors.white,),
                                  SizedBox(width: 50,),
                                  Text(
                                    audioPlayerModel.currentMedia.title,
                                    maxLines: 1,
                                    style: TextStyles.subhead(context).copyWith(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                  SizedBox(width: 50,),
                                  Icon (Icons.file_download, color: Colors.white,) ,

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
                              style: TextStyles.subhead(context)
                                  .copyWith(fontSize: 15, color: Colors.white),
                            ),
                          ),
                          Player(),
                          MediaCommentsLikesContainer(
                              key: UniqueKey(),
                              context: context,
                              audioPlayerModel: audioPlayerModel,
                              currentMedia: audioPlayerModel.currentMedia),
                          Banneradmob(),

                        ],
                      )
                    : SongListCarousel(),
              ],
            ),
          ),

         // Player(),
         //  MediaCommentsLikesContainer(
         //      key: UniqueKey(),
         //      context: context,
         //      audioPlayerModel: audioPlayerModel,
         //      currentMedia: audioPlayerModel.currentMedia),

          // Banneradmob(),
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
         // color:Colors.red,
          height: 50,
          margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(width: 02,),
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
              SizedBox(width: 02,),
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
              SizedBox(width: 02,),
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
              SizedBox(width: 02,),
              IconButton(
                onPressed: () => null,//widget.audioPlayerModel
                  //  .setShowList(!widget.audioPlayerModel.showList),
                icon: Icon(
                  Icons.playlist_play,
                  size: 27.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 02,),
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
