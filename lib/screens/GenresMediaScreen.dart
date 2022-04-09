import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:HolyTune/models/Genres.dart';
import '../i18n/strings.g.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/Media.dart';
import '../providers/GenreMediaScreensModel.dart';
import '../widgets/MediaItemTile.dart';
import '../screens/NoitemScreen.dart';
import '../screens/genresNavHeader.dart';

class GenresMediaScreen extends StatelessWidget {
  static const routeName = "/GenresMediaScreen";

  GenresMediaScreen({this.genreList});

  final List<Genres> genreList;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GenreMediaScreensModel(genreList),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            t.genress,
            maxLines: 1,
          ),
        ),
        body: Container(
          // decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: <Widget>[
              genresNavHeader(),
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(0),
                child: MediaScreen(),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class MediaScreen extends StatefulWidget {
  MediaScreen();

  @override
  _CategoriesMediaScreenState createState() => _CategoriesMediaScreenState();
}

class _CategoriesMediaScreenState extends State<MediaScreen> {
  GenreMediaScreensModel mediaScreensModel;
  List<Media> items;

  void _onRefresh() async {
    mediaScreensModel.loadItems();
  }

  void _onLoading() async {
    mediaScreensModel.loadMoreItems();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<GenreMediaScreensModel>(context, listen: false).loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    mediaScreensModel = Provider.of<GenreMediaScreensModel>(context);
    items = mediaScreensModel.mediaList;

    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text(t.pulluploadmore);
          } else if (mode == LoadStatus.loading) {
            body = CircularProgressIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text(t.loadfailedretry);
          } else if (mode == LoadStatus.canLoading) {
            body = Text(t.releaseloadmore);
          } else {
            body = Text(t.nomoredata);
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: mediaScreensModel.refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: (mediaScreensModel.isError == true || items.length == 0)
          ? NoitemScreen(
              title: t.oops, message: t.noitemstodisplay, onClick: _onRefresh)
          : ListView.builder(
              itemCount: items.length,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(3),
              itemBuilder: (BuildContext context, int index) {
                return ItemTile(
                  mediaList: items,
                  index: index,
                  object: items[index],
                );
              },
            ),
    );
  }
}
