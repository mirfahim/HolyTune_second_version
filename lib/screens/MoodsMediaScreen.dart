import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Moods.dart';
import '../i18n/strings.g.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/Media.dart';
import '../providers/MoodsMediaScreensModel.dart';
import '../widgets/MediaItemTile.dart';
import '../screens/NoitemScreen.dart';
import 'package:shape_of_view/shape_of_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MoodsMediaScreen extends StatelessWidget {
  static const routeName = "/MoodsMediaScreen";

  MoodsMediaScreen({this.moods});

  final Moods moods;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MoodsMediaScreensModel(moods),
      child: SafeArea(
        child: Scaffold(
          body: Container(
            // decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: <Widget>[
                Stack(
                  children: [
                    ShapeOfView(
                      elevation: 4,
                      height: 80,
                      shape: ArcShape(
                        direction: ArcDirection.Outside,
                        height: 5,
                        position: ArcPosition.Bottom,
                      ),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: moods.thumbnail,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                        Colors.black45, BlendMode.darken)),
                              ),
                            ),
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Center(
                                child: Icon(
                              Icons.error,
                              color: Colors.grey,
                            )),
                          ),
                          Positioned(
                            left: 40,
                            top: 30,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 16, top: 0.0),
                                  child: Text(
                                    moods.title,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontSize: 18,
                                        shadows: [
                                          Shadow(
                                              color: Colors.black,
                                              blurRadius: 1,
                                              offset: Offset(1, 1)),
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 0, top: 10),
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.white,
                            size: 40,
                          )),
                    ),
                  ],
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.all(0),
                  child: MediaScreen(),
                ))
              ],
            ),
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
  MoodsMediaScreensModel mediaScreensModel;
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
      Provider.of<MoodsMediaScreensModel>(context, listen: false).loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    mediaScreensModel = Provider.of<MoodsMediaScreensModel>(context);
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
