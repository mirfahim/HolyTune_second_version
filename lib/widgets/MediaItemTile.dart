import 'package:HolyTune/providers/AppStateNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../utils/TextStyles.dart';
import '../utils/TimUtil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/Media.dart';
import '../widgets/MediaPopupMenu.dart';
import '../utils/Utility.dart';
import '../utils/Alerts.dart';
import '../providers/AudioPlayerModel.dart';
import '../audio_player/player_page.dart';

class ItemTile extends StatefulWidget {
  final Media object;
  final List<Media> mediaList;
  final int index;

  const ItemTile({
    Key key,
    @required this.mediaList,
    @required this.index,
    @required this.object,
  })  : assert(mediaList != null),
        assert(index != null),
        assert(object != null),
        super(key: key);

  @override
  _ItemTileState createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  AppStateNotifier appState;
  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppStateNotifier>(context);
    bool isSubscribed = true;
    return InkWell(
      onTap: () {
        print("${widget.object.coverPhoto}");
        if (Utility.isMediaRequireUserSubscription(
            widget.object, isSubscribed)) {
          Alerts.showPlaySubscribeAlertDialog(context);
          return;
        }
        Provider.of<AudioPlayerModel>(context, listen: false).preparePlaylist(
            Utility.extractMediaByType(
                widget.mediaList, widget.object.mediaType),
            widget.object);
        Navigator.of(context).pushNamed(PlayPage.routeName);
      },
      child: Container(

        height: 80,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(15, 0.2, 10, 0),
        child: Column(

          children: <Widget>[
            Expanded(
              child: Row(

                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(

                        margin: EdgeInsets.all(0.5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Container(

                          height: 60,
                          width: 60,
                          child: CachedNetworkImage(
                            imageUrl:widget.object.coverPhoto,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                        Colors.black12, BlendMode.darken)),
                              ),
                            ),
                            placeholder: (context, url) =>

                                Center(child: CupertinoActivityIndicator()),
                            errorWidget: (context, url, error) => Image(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/images/holy_tune_logo_512_blue_bg.png")),
                          ),
                        )
                    ),
                  ),
                  Container(width: 10),

                  Expanded(
                    child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                       SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 4, 0, 0),
                          child: Row(
                            children: <Widget>[
                              Text(widget.object.artist,
                                  style: TextStyles.caption(context)

                                  .copyWith(fontSize: 14),
                                  ),
                              Spacer(),
                              Text(
                                  TimUtil.timeFormatter(widget.object.duration),
                                  style: TextStyles.caption(context)

                                  .copyWith(color: appState.isDarkModeOn == false ?
                                  Colors.black54 : Colors.white54, ),
                                  ),
                            ],
                          ),

                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(widget.object.title,
                                maxLines: 2,
                                style: TextStyles.subhead(context).copyWith(

                                    //color: MyColors.grey_80,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal)),
                          ),
                        ),


                            widget.object.viewsCount == 0
                                ? Container()
                                : Padding(
                              padding: EdgeInsets.only(left: 05),
                                  child: Text(
                                      widget.object.viewsCount.toString() +
                                          " plays",
                                      style: appState.isDarkModeOn == false ?
                                      TextStyle(color: Colors.black54, fontSize: 12)
                                          : TextStyle(color: Colors.white54, fontSize: 12)



                                    //.copyWith(color: MyColors.grey_60),
                                      ),
                                ),

                            // Align(
                            //   alignment: Alignment.centerRight,
                            //   child: MediaPopupMenu(widget.object),
                            // ),

                      ],
                    ),
                  )
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }
}
