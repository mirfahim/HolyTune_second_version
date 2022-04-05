import 'package:HolyTune/providers/AppStateNotifier.dart';
import 'package:HolyTune/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/PlaylistsModel.dart';
import '../models/Playlists.dart';
import '../i18n/strings.g.dart';
import '../utils/TextStyles.dart';
import '../models/Media.dart';
import '../widgets/MediaItemTile.dart';

class PlaylistMediaScreen extends StatefulWidget {
  static const routeName = "/playlistsmedia";
  final Playlists playlists;
  PlaylistMediaScreen({this.playlists});

  @override
  _PlaylistMediaScreenState createState() => _PlaylistMediaScreenState();
}

class _PlaylistMediaScreenState extends State<PlaylistMediaScreen> {
  AppStateNotifier appState;
  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppStateNotifier>(context);
    PlaylistsModel playlistsModel = Provider.of<PlaylistsModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appState.isDarkModeOn != true ? MyColors.softBlueColor : Colors.black54,

        title: Text(
          widget.playlists.title + " " + t.playlistitm,
          maxLines: 1,
        ),
      ),
      body: Container(
        // decoration: BoxDecoration(color: Colors.white),
        child: FutureBuilder<List<Media>>(
            future:
                playlistsModel.getPlaylistsMedia(widget.playlists.id), //returns bool
            builder: (BuildContext context, AsyncSnapshot<List<Media>> value) {
              if (value.data == null) {
                return Center();
              }
              List<Media> items = value.data;
              if (items.length == 0)
                return Center(
                  child: Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(t.noitemstodisplay,
                          textAlign: TextAlign.center,
                          style: TextStyles.medium(context)),
                    ),
                  ),
                );
              else
                return Container(
                  padding: EdgeInsets.all(0),
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ItemTile(
                        mediaList: items,
                        index: index,
                        object: items[index],
                      );
                    },
                  ),
                );
            }),
      ),
    );
  }
}
