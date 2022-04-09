import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../screens/AudioListPage.dart';
import '../screens/TrendingListPage.dart';
import '../providers/AudioPlayerModel.dart';
import '../utils/TextStyles.dart';
import '../models/Media.dart';
import '../widgets/MediaPopupMenu.dart';
import '../i18n/strings.g.dart';
import '../audio_player/player_page.dart';
import '../utils/Utility.dart';
import '../utils/Alerts.dart';

class VideosMediaListView extends StatelessWidget {
  VideosMediaListView(this.mediaList, this.header, this.subHeader);

  final List<Media> mediaList;
  final String header;
  final String subHeader;

  Widget _buildItems(BuildContext context, int index) {
    var media = mediaList[index];
    bool isSubscribed = true;

    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: InkWell(
        child: Container(
          height: 200.0,
          width: 200.0,
          child: Column(
            children: <Widget>[
              Container(
                width: 250,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: media.coverPhoto == null
                      ? Text("Hlw")
                      : CachedNetworkImage(
                          imageUrl: media.coverPhoto,
                          imageBuilder: (context, imageProvider) => Container(
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
                            fit: BoxFit.fitWidth,
                            image: AssetImage(
                                "assets/images/holy_tune_logo_512_blue_bg.png"),
                          ),
                        ),
                ),
              ),
              SizedBox(height: 7.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            media.title,
                            style: TextStyles.headline(context).copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 3.0),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            media.artist,
                            style: TextStyles.subhead(context).copyWith(
                              //fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                              //color: Colors.blueGrey[300],
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MediaPopupMenu(media),
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          if (Utility.isMediaRequireUserSubscription(media, isSubscribed)) {
            Alerts.showPlaySubscribeAlertDialog(context);
            return;
          }
          Provider.of<AudioPlayerModel>(context, listen: false).preparePlaylist(
              Utility.extractMediaByType(mediaList, media.mediaType), media);
          Navigator.of(context).pushNamed(PlayPage.routeName);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 2),
                    child: Text(
                      header,
                      //textAlign: TextAlign.start,
                      maxLines: 1,
                      style: TextStyles.headline(context).copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                subHeader == ""
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Text(subHeader,
                            maxLines: 1,
                            style: TextStyles.subhead(context).copyWith(
                              fontSize: 13,
                              // color: Colors.grey[600],
                            )),
                      ),
              ],
            ),
            Spacer(),
            header != t.bookmarksMedia
                ? InkWell(
                    onTap: () {
                      if (header == t.trendingvideos ||
                          header == t.trendingaudios) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TrendingListPage()),
                        );
                      }
                      if (header == t.audiotracks) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AudioListPage()),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 10, 10),
                      child: Icon(
                        Icons.navigate_next,
                        size: 25,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        mediaList.length == 0
            ? Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(t.noitemstodisplay,
                      textAlign: TextAlign.center,
                      style: TextStyles.medium(context)),
                ),
              )
            : Container(
                padding: EdgeInsets.only(top: 15.0, left: 20.0),
                height: 200.0,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  primary: false,
                  itemCount: mediaList.length,
                  itemBuilder: _buildItems,
                ),
              ),
      ],
    );
  }
}
