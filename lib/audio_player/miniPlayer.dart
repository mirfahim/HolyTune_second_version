import 'package:HolyTune/utils/TimUtil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../widgets/ads_admob.dart';
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
    // ads Implimentetion Start
    final BannerAd myBanner = BannerAd(
      adUnitId: 'ca-app-pub-2662237367678556/9607124603',
      size: AdSize(width: 468, height: 60),
      request: AdRequest(),
      listener: BannerAdListener(),
    );
    // ads Implimentetion End
    bool isSubscribed = true;
    Provider.of<AudioPlayerModel>(context, listen: false)
        .setUserSubscribed(isSubscribed);
    Provider.of<AudioPlayerModel>(context, listen: false).setContext(context);
    return Consumer<AudioPlayerModel>(
      builder: (context, audioPlayerModel, child) {
        Media mediaItem = audioPlayerModel.currentMedia;
        // print("------------------------------------");
        // print(mediaItem.coverPhoto);
        // print("------------------------------------");
        return mediaItem == null
            ? Container()
            : Column(children: [
                // Banneradmob(),
                BannerAdmob(bannerAd: myBanner),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(PlayPage.routeName);
                  },
                  child: SizedBox(
                    height: 70,
                    child: Card(
                        color: Color(0xFF17a5e5),
                        //color: audioPlayerModel.backgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        margin: EdgeInsets.all(0),
                        elevation: 10,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF17a5e5),
                                Color(0xFFB36500),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              CachedNetworkImage(
                                imageUrl:
                                    audioPlayerModel.currentMedia.coverPhoto,
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  backgroundColor: Color(0xFF015E68),
                                  radius: 30,
                                  child: CircleAvatar(
                                    radius: 27,
                                    backgroundImage: imageProvider,
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    Center(child: CupertinoActivityIndicator()),
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(
                                  backgroundColor: Color(0xFF015E68),
                                  radius: 30,
                                  child: CircleAvatar(
                                    radius: 27,
                                    backgroundImage:
                                        AssetImage('assets/images/01.jpg'),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: MarqueeWidget(
                                  direction: Axis.horizontal,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            mediaItem != null
                                                ? TimUtil.timeFormatter(
                                                    mediaItem.duration)
                                                : "",
                                            maxLines: 1,
                                            textAlign: TextAlign.start,
                                            style: TextStyles.subhead(context)
                                                .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            mediaItem != null
                                                ? mediaItem.title
                                                : "",
                                            maxLines: 1,
                                            style: TextStyles.subhead(context)
                                                .copyWith(
                                              fontSize: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                          // SizedBox(
                                          //   height: 05,
                                          // ),
                                          Text(
                                            mediaItem != null
                                                ? mediaItem.artist
                                                : "",
                                            maxLines: 1,
                                            style: TextStyles.subhead(context)
                                                .copyWith(
                                              fontSize: 12,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ]),
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
                                Icons.favorite_border,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 05,
                              ),
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
              ]);
      },
    );
  }
}
