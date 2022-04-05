import 'package:HolyTune/database/SharedPreference.dart';
import 'package:HolyTune/utils/TimUtil.dart';
import 'package:HolyTune/widgets/Banneradmob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'player_page.dart';
import '../providers/AudioPlayerModel.dart';
import '../models/Media.dart';
import '../utils/my_colors.dart';
import '../utils/TextStyles.dart';
import '../widgets/MarqueeWidget.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key key}) : super(key: key);

  @override
  _AudioPlayout createState() => _AudioPlayout();
}

class _AudioPlayout extends State<MiniPlayer> {
  @override
  Widget build(BuildContext context) {
    bool isSubscribed = true;
    Provider.of<AudioPlayerModel>(context, listen: false)
        .setUserSubscribed(isSubscribed);
    Provider.of<AudioPlayerModel>(context, listen: false).setContext(context);
    return Consumer<AudioPlayerModel>(
      builder: (context, audioPlayerModel, child) {
        Media mediaItem = audioPlayerModel.currentMedia;
        return mediaItem == null
            ? Container()
            : Column(
              children:[
                Banneradmob(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(PlayPage.routeName);
                  },
                  child: Container(
                    height:70,
                    //color: Colors.grey[900],
                    child: Card(
                        color:Colors.blueAccent,
                        //color: audioPlayerModel.backgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        margin: EdgeInsets.all(0),
                        elevation: 10,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              mediaItem == null
                                  ? Container()
                                  : (mediaItem.coverPhoto == ""
                                  ? Icon(Icons.audiotrack, color: Colors.white,)
                                  : Container(
                                height: 65,
                                width: 65,
                                decoration: BoxDecoration(

                                  color: Colors.white,
                                  //shape: BoxShape.circle,
                                  border: Border.all(color:Colors.blue),
                                  boxShadow:  [
                                    BoxShadow(
                                      color: Colors.blue,
                                      blurRadius: 25.0, // soften the shadow
                                      spreadRadius: 5.0, //extend the shadow
                                      offset: Offset(
                                        15.0, // Move to right 10  horizontally
                                        02.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ],
                                  // borderRadius: BorderRadius.circular(1),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit:  BoxFit.cover,
                                    image: NetworkImage(
                                     mediaItem.coverPhoto.contains("https://adminapplication.com/uploads/") ? mediaItem.coverPhoto : SharedPref.imageURL + mediaItem.coverPhoto ),
                                  ),

                                ),


                              )
                              ),
                              Container(
                                width: 12,
                              ),
                              Expanded(
                                child: MarqueeWidget(
                                  direction: Axis.horizontal,
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:[
                                        Text(
                                          mediaItem != null ? TimUtil.timeFormatter(mediaItem.duration): "",
                                          maxLines: 1,
                                          textAlign: TextAlign.start,
                                          style: TextStyles.subhead(context)
                                              .copyWith(fontSize: 9,color: Colors.white),

                                        ),
                                        Text(
                                          mediaItem != null ? mediaItem.title : "",
                                          maxLines: 1,
                                          style: TextStyles.subhead(context)
                                              .copyWith(fontSize: 13, color: Colors.white,),

                                        ),
                                        SizedBox(height:05,),
                                        Text(
                                          mediaItem != null ? mediaItem.artist : "",
                                          maxLines: 1,
                                          style: TextStyles.subhead(context)
                                              .copyWith(fontSize: 9,color: Colors.white),

                                        ),
                                      ]
                                  ),
                                ),
                              ),
                              // IconButton(
                              //   padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              //   onPressed: () {
                              //     audioPlayerModel.skipPrevious();
                              //   },
                              //   icon: const Icon(
                              //
                              //     Icons.skip_previous,
                              //     size: 20,
                              //     color: Colors.white,
                              //   ),
                              // ),
                              Icon(
                                Icons.favorite_border,color: Colors.white,
                              ),
                              SizedBox(width: 05,),
                              IconButton(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 2),

                                onPressed: () {
                                  audioPlayerModel.onPressed();
                                },
                                icon: audioPlayerModel.icon(true),
                                color: Colors.white,
                              ),

                              // ClipOval(
                              //     child: Container(
                              //   color:
                              //       Theme.of(context).accentColor.withAlpha(30),
                              //   width:30, //50.0,
                              //   height:30, //50.0,
                              //   child: IconButton(
                              //     padding: EdgeInsets.fromLTRB(0, 0, 15, 15),
                              //     onPressed: () {
                              //       audioPlayerModel.onPressed();
                              //     },
                              //     icon: audioPlayerModel.icon(true),
                              //     color: Colors.white,
                              //   ),
                              // )),
                              // IconButton(
                              //   padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              //   onPressed: () {
                              //     audioPlayerModel.skipNext();
                              //   },
                              //   icon: const Icon(
                              //     Icons.skip_next,
                              //     size: 30,
                              //     color: Colors.white,
                              //   ),
                              // ),
                              Container(
                                color: MyColors.primary,
                                //width: 100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ]
            );
      },
    );
  }
}
