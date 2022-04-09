import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/Media.dart';
import '../providers/AudioPlayerModel.dart';
import '../audio_player/player_page.dart';
import '../utils/Utility.dart';
import '../utils/TextStyles.dart';

class HomeSlider extends StatelessWidget {
  final List<Media> items;

  HomeSlider(this.items);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: EdgeInsets.only(top: 10.0, left: 10.0),
          height: 160.0,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            primary: false,
            itemCount: (items == null || items.length == 0) ? 0 : items.length,
            itemBuilder: (BuildContext context, int index) {
              Media curObj = items[index];
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: InkWell(
                  child: Container(
                    height: 200.0,
                    width: 100.0,
                    child: Column(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 100.0,
                            width: 100.0,
                            child: CachedNetworkImage(
                              imageUrl: curObj.coverPhoto,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Image(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      "assets/images/holy_tune_logo_512_blue_bg.png")),
                            ),
                          ),
                        ),
                        SizedBox(height: 7.0),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            curObj.title,
                            style: TextStyles.headline(context).copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 13.0,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 3.0),
                        // Container(
                        //   alignment: Alignment.centerLeft,
                        //   child: Text(
                        //     curObj.artist,
                        //     style: TextStyles.subhead(context).copyWith(
                        //       //fontWeight: FontWeight.bold,
                        //       fontSize: 13.0,
                        //       //color: Colors.blueGrey[300],
                        //     ),
                        //     maxLines: 1,
                        //     textAlign: TextAlign.left,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Provider.of<AudioPlayerModel>(context, listen: false)
                        .preparePlaylist(
                            Utility.extractMediaByType(
                                Utility.extractMediaByType(
                                    items, curObj.mediaType),
                                curObj.mediaType),
                            curObj);
                    Navigator.of(context).pushNamed(PlayPage.routeName);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
