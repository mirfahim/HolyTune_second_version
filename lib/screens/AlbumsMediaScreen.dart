import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:HolyTune/utils/TimUtil.dart';
import '../models/Albums.dart';
import '../i18n/strings.g.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/Media.dart';
import '../providers/AlbumsMediaScreensModel.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/MediaItemTile.dart';
import '../screens/NoitemScreen.dart';
import 'package:shape_of_view/shape_of_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AlbumsMediaScreen extends StatelessWidget {
  static const routeName = "/AlbumsMediaScreen";
  AlbumsMediaScreen({this.albums});
  final Albums albums;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AlbumsMediaScreensModel(albums),
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
                      height: 250,
                      shape: DiagonalShape(
                        position: DiagonalPosition.Bottom,
                        direction: DiagonalDirection.Left,
                        angle: DiagonalAngle.deg(angle: 10),
                      ),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: albums.thumbnail,
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
                                Center(child: CupertinoActivityIndicator()),
                            errorWidget: (context, url, error) => Center(
                                child: Icon(
                              Icons.error,
                              color: Colors.grey,
                            )),
                          ),
                          Positioned(
                            right: 10,
                            left: 150,
                            top: 120,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 16, top: 0.0),
                                  child: Text(
                                    albums.title,
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
                                Padding(
                                  padding: EdgeInsets.only(left: 18, top: 0),
                                  child: Text(
                                    albums.artist,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        color: Colors.white,
                                        fontSize: 20,
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
                      margin: EdgeInsets.only(left: 20, top: 180),
                      child: ShapeOfView(
                        height: 100,
                        width: 100,
                        shape: CircleShape(
                            borderColor: Colors.white, borderWidth: 1),
                        elevation: 12,
                        child: CachedNetworkImage(
                          imageUrl: albums.artistAvatar,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Color.fromARGB(31, 211, 206, 206),
                                      BlendMode.darken)),
                            ),
                          ),
                          placeholder: (context, url) =>
                              Center(child: CupertinoActivityIndicator()),
                          errorWidget: (context, url, error) => Center(
                              child: Icon(
                            Icons.error,
                            color: Colors.grey,
                          )),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 140, top: 220),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 16, top: 0.0),
                                child: Text(
                                  t.audiotracks,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      shadows: [
                                        // Shadow(
                                        //     color: Color.fromARGB(
                                        //         255, 255, 254, 254),
                                        //     blurRadius: 1,
                                        //     offset: Offset(1, 1)),
                                      ]),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 18, top: 0),
                                child: Text(
                                  albums.mediaCount.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 0, top: 0.0),
                                child: Text(
                                  t.duration,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      shadows: [
                                        Shadow(
                                            color: Colors.black,
                                            blurRadius: 1,
                                            offset: Offset(1, 1)),
                                      ]),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 18, top: 0, right: 12),
                                child: Consumer<AlbumsMediaScreensModel>(
                                  builder: (context, albumsMediaScreen, child) {
                                    return Text(
                                      TimUtil.timeFormatter(
                                          albumsMediaScreen.albumDuration),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 12,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
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
  AlbumsMediaScreensModel mediaScreensModel;
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
      Provider.of<AlbumsMediaScreensModel>(context, listen: false).loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    mediaScreensModel = Provider.of<AlbumsMediaScreensModel>(context);
    items = mediaScreensModel.mediaList;

    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text(t.pulluploadmore);
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
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
