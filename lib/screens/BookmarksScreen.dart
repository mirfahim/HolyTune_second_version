import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import '../utils/TextStyles.dart';
import '../models/Media.dart';
import '../i18n/strings.g.dart';
import '../providers/BookmarksModel.dart';
import '../widgets/MediaItemTile.dart';

class BookmarksScreen extends StatefulWidget {
  BookmarksScreen(this.title);
  final String title;

  @override
  MediaScreenRouteState createState() => new MediaScreenRouteState();
}

class MediaScreenRouteState extends State<BookmarksScreen> {
  BookmarksModel mediaScreensModel;
  List<Media> items;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mediaScreensModel = Provider.of<BookmarksModel>(context);
    items = mediaScreensModel.bookmarksList;
    return (items.length == 0)
        ? Center(
            child: Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(t.noitemstodisplay,
                    textAlign: TextAlign.center,
                    style: TextStyles.medium(context)),
              ),
            ),
          )
        : ListView.builder(
            itemCount: items.length + 1,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(3),
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
                    child: Text(widget.title,
                        style: TextStyles.headline(context).copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                  ),
                );
              } else {
                int _indx = 5;
                return ItemTile(
                  mediaList: items,
                  index: _indx,
                  object: items[_indx],
                );
              }
            },
          );
  }
}
