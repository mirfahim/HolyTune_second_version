import 'package:HolyTune/providers/AppStateNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../screens/AlbumsScreen.dart';
import '../utils/TextStyles.dart';
import '../models/Albums.dart';
import '../i18n/strings.g.dart';
import '../models/ScreenArguements.dart';
import '../screens/AlbumsMediaScreen.dart';

class AlbumsListView extends StatefulWidget {
  AlbumsListView(this.albums);
  final List<Albums> albums;

  @override
  _AlbumsListViewState createState() => _AlbumsListViewState();
}

class _AlbumsListViewState extends State<AlbumsListView> {
  AppStateNotifier appState;
  Widget _buildItems(BuildContext context, int index) {
    appState = Provider.of<AppStateNotifier>(context);
    var cats = widget.albums[index];

    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: InkWell(
        child: SizedBox(
          height: 200.0,
          width: 100.0,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 100,
                //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: cats.thumbnail,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        Center(child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) => Center(
                        child: Image(
                            fit: BoxFit.cover,
                            image:
                                AssetImage("assets/images/launcher_icon.png"))),
                    //     child: Icon(
                    //   Icons.error,
                    //   color: Colors.grey,
                    // )),
                  ),
                ),
              ),
              SizedBox(height: 7.0),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  cats.title,
                  style: TextStyles.headline(context).copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: 13.0,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 3.0),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  cats.mediaCount.toString() + " " + t.tracks,
                  style: appState.isDarkModeOn == false
                      ? TextStyles.headline(context).copyWith(
                          //fontWeight: FontWeight.bold,
                          fontSize: 11.0,
                        )
                      : TextStyles.headline(context).copyWith(
                          color: Colors.white54,
                          fontSize: 11.0,
                        ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            AlbumsMediaScreen.routeName,
            arguments: ScreenArguements(position: 0, items: cats),
          );
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
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 10, 10),
              child: Text(t.albums,
                  style: TextStyles.headline(context).copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  )),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AlbumsScreen.routeName,
                );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 20, 10),
                child: Icon(
                  Icons.navigate_next,
                  size: 25,
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(top: 10.0, left: 20.0),
          height: 155.0,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            primary: false,
            itemCount: widget.albums.length,
            itemBuilder: _buildItems,
          ),
        ),
      ],
    );
  }
}
