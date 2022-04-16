import 'package:HolyTune/providers/AppStateNotifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../screens/AudioListPage.dart';
import '../screens/TrendingListPage.dart';
import '../providers/AudioPlayerModel.dart';
import '../utils/TextStyles.dart';
import '../models/Media.dart';
import '../i18n/strings.g.dart';
import '../audio_player/player_page.dart';
import '../utils/Utility.dart';
import '../utils/Alerts.dart';

class MediaListView extends StatefulWidget {
  MediaListView(this.mediaList, this.header, this.subHeader);

  final List<Media> mediaList;
  final String header;
  final String subHeader;

  @override
  _MediaListViewState createState() => _MediaListViewState();
}

class _MediaListViewState extends State<MediaListView> {
  AppStateNotifier appState;

  Widget _buildItems(BuildContext context, int index) {
    appState = Provider.of<AppStateNotifier>(context);
    var media = widget.mediaList[index];
    bool isSubscribed = true;
    return Padding(
      padding: EdgeInsets.only(right: 10.0),
      child: InkWell(
        child: SizedBox(
          height: 180.0,
          width: 100.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 100,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: media.coverPhoto == null
                      ? Image(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/01.jpg"),
                        )
                      : CachedNetworkImage(
                          imageUrl: media.coverPhoto,
                          // https://adminapplication.com/uploads/thumbnails/media/1623414931.jpg
                          imageBuilder: (context, imageProvider) {
                            //  print("__________AUDIO_____IMAGE______${SharedPref.imageURL + media.coverPhoto}");

                            //To Do:

                            print(
                                "__________AUDO_____IMAGE______${media.coverPhoto}");

                            return Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Image(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/01.jpg"),
                          ),
                        ),
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            media.title,
                            style: TextStyles.headline(context).copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 13.0,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 3.0),
                      ],
                    ),
                  ),
                  //  MediaPopupMenu(media),
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
              Utility.extractMediaByType(widget.mediaList, media.mediaType),
              media);
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
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 2),
                    child: Text(
                      widget.header,
                      //textAlign: TextAlign.start,
                      maxLines: 1,
                      style: TextStyles.headline(context).copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
                widget.subHeader == ""
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Text(widget.subHeader,
                            maxLines: 1,
                            style: TextStyles.subhead(context).copyWith(
                              fontSize: 13,
                              color: Colors.grey[600],
                            )),
                      ),
              ],
            ),
            Spacer(),
            widget.header != t.bookmarksMedia
                ? InkWell(
                    onTap: () {
                      if (widget.header == t.trendingvideos ||
                          widget.header == t.trendingaudios) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TrendingListPage()),
                        );
                      }
                      if (widget.header == t.audiotracks) {
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
        widget.mediaList.isEmpty
            ? SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(t.noitemstodisplay,
                      textAlign: TextAlign.center,
                      style: TextStyles.medium(context)),
                ),
              )
            : Container(
                padding: EdgeInsets.only(top: 15.0, left: 20.0),
                height: 160.0,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  primary: false,
                  itemCount: widget.mediaList.length,
                  itemBuilder: _buildItems,
                ),
              ),
      ],
    );
  }
}
