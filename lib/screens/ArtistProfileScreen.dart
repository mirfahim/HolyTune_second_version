import 'package:HolyTune/widgets/NewMediaListTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:HolyTune/providers/AppStateNotifier.dart';
import '../models/Albums.dart';
import '../models/ScreenArguements.dart';
import '../screens/AlbumsMediaScreen.dart';
import '../utils/Utility.dart';
import '../utils/my_colors.dart';
import 'dart:math' as math;
import '../models/Artists.dart';
import '../i18n/strings.g.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/Media.dart';
import '../providers/ArtistsMediaModel.dart';
import '../providers/ArtistsAlbumsModel.dart';
import 'package:flutter/cupertino.dart';
import '../screens/NoitemScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ArtistProfileScreen extends StatelessWidget {
  static const routeName = "/ArtistProfileScreen";
  ArtistProfileScreen({this.artists});
  final Artists artists;

  @override
  Widget build(BuildContext context) {
    AppStateNotifier appStateNotifier = Provider.of<AppStateNotifier>(context);
    // print(routeName + " -----------------------------------");
    print(artists.biography);
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Color.fromARGB(255, 105, 57, 124),
        body: DefaultTabController(
          length: 2, // length of tabs
          initialIndex: 0,
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  // ShapeOfView(
                  //   elevation: 4,
                  //   height: 200,
                  //   shape: DiagonalShape(
                  //     position: DiagonalPosition.Bottom,
                  //     direction: DiagonalDirection.Left,
                  //     angle: DiagonalAngle.deg(angle: 10),
                  //   ),
                  //   child: Container(
                  //     height: 130,
                  //     foregroundDecoration: BoxDecoration(
                  //         // image: DecorationImage(image: image),
                  //         color: Color.fromARGB(255, 123, 133, 134)),
                  //   ),
                  // ),
                  SizedBox(
                    height: 50,
                  ),
                  CachedNetworkImage(
                    imageUrl: artists.thumbnail,
                    imageBuilder: (context, imageProvider) => Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
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
                        image: AssetImage(
                            "assets/images/holy_tune_logo_512_blue_bg.png"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, top: 0.0),
                    child: Text(
                      artists.title,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 255, 250, 250),
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "500 followings",
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 148, 144, 144)),
                      ),
                      Text(
                        ". 5000 monthly Listeners",
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 129, 127, 127)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Center(
                      child: Text(
                        "Follow",
                        style: TextStyle(
                            color: Color(0xFFE0E0E0),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 1),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Biography",
                          style: TextStyle(
                              color: Color(0xFFFAFAFA),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          artists.biography,
                          style: TextStyle(color: Color(0x88F6F3F3)),
                        ),
                      ],
                    ),
                  ),
                  // Tab Bar
                  TabBar(
                    indicatorColor: MyColors.accent,
                    labelColor: MyColors.accent,
                    unselectedLabelColor: appStateNotifier.isDarkModeOn
                        ? Colors.white
                        : Color(0xFFFAF9F9),
                    tabs: [
                      Tab(
                          text: t.audiotracks +
                              " (" +
                              artists.mediaCount.toString() +
                              ")"),
                      Tab(
                          text: t.albums +
                              " (" +
                              artists.albumCount.toString() +
                              ")"),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(0),
                      child: TabBarView(
                        children: [
                          ChangeNotifierProvider(
                            create: (context) => ArtistsMediaModel(artists),
                            child: MediaScreen(),
                          ),
                          ChangeNotifierProvider(
                            create: (context) => ArtistsAlbumsModel(artists),
                            child: ArtistAlbumsScreen(),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                height: 0,
                left: 0,
                child: Container(
                  margin: EdgeInsets.only(left: 0, top: 10),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.white54,
                        size: 40,
                      )),
                ),
              ),
              Positioned(
                height: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsets.only(right: 10, top: 10),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.share,
                        color: Color.fromARGB(137, 251, 249, 249),
                        size: 30,
                      )),
                ),
              ),
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

class _CategoriesMediaScreenState extends State<MediaScreen>
    with AutomaticKeepAliveClientMixin {
  ArtistsMediaModel mediaScreensModel;
  List<Media> items;

  @override
  bool get wantKeepAlive => true;

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
      Provider.of<ArtistsMediaModel>(context, listen: false).loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    mediaScreensModel = Provider.of<ArtistsMediaModel>(context);
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
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text(t.loadfailedretry);
          } else if (mode == LoadStatus.canLoading) {
            body = Text(t.releaseloadmore);
          } else {
            body = Text(t.nomoredata);
          }
          return SizedBox(
            height: 20.0,
            child: Center(child: body),
          );
        },
      ),
      controller: mediaScreensModel.refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: (mediaScreensModel.isError == true && items.isEmpty)
          ? NoitemScreen(
              title: t.oops, message: t.dataloaderror, onClick: _onRefresh)
          : ListView.builder(
              itemCount: items.length,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(3),
              itemBuilder: (BuildContext context, int index) {
                return NewItemTile(
                  mediaList: items,
                  index: index,
                  object: items[index],
                );
              },
            ),
    );
  }
}

class ArtistAlbumsScreen extends StatefulWidget {
  ArtistAlbumsScreen();

  @override
  _AlbumsScreenState createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<ArtistAlbumsScreen>
    with AutomaticKeepAliveClientMixin {
  ArtistsAlbumsModel mediaScreensModel;
  List<Albums> items;

  void _onRefresh() async {
    mediaScreensModel.loadItems();
  }

  void _onLoading() async {
    mediaScreensModel.loadMoreItems();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<ArtistsAlbumsModel>(context, listen: false).loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    mediaScreensModel = Provider.of<ArtistsAlbumsModel>(context);
    items = mediaScreensModel.albumsList;

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
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text(t.loadfailedretry);
          } else if (mode == LoadStatus.canLoading) {
            body = Text(t.releaseloadmore);
          } else {
            body = Text(t.nomoredata);
          }
          return SizedBox(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: mediaScreensModel.refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: (mediaScreensModel.isError == true && items.isEmpty)
          ? NoitemScreen(
              title: t.oops, message: t.dataloaderror, onClick: _onRefresh)
          : GridView.builder(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(3),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 0.0,
                  childAspectRatio: 1.1),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return AlbumTile(
                  index: index,
                  albums: items[index],
                );
              },
            ),
    );
  }
}

class AlbumTile extends StatelessWidget {
  final Albums albums;
  final int index;

  const AlbumTile({
    Key key,
    @required this.index,
    @required this.albums,
  })  : assert(index != null),
        assert(albums != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: InkWell(
        child: SizedBox(
          // height: 200.0,
          width: 120.0,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 120,
                //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    // height: 180,
                    imageUrl: albums.thumbnail,
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
                        child: Icon(
                      Icons.error,
                      color: Colors.grey,
                    )),
                  ),
                ),
              ),
              SizedBox(height: 7.0),
              Container(
                alignment: Alignment.center,
                child: Text(
                  albums.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 3.0),
              Container(
                alignment: Alignment.center,
                child: Text(
                  Utility.formatNumber(albums.mediaCount) + " " + t.tracks,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                    color: Colors.blueGrey[300],
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
            arguments: ScreenArguements(position: 0, items: albums),
          );
        },
      ),
    );
  }
}

class BadgeDecoration extends Decoration {
  final Color badgeColor;
  final double badgeSize;
  final TextSpan textSpan;

  const BadgeDecoration(
      {@required this.badgeColor,
      @required this.badgeSize,
      @required this.textSpan});

  @override
  BoxPainter createBoxPainter([onChanged]) =>
      _BadgePainter(badgeColor, badgeSize, textSpan);
}

class _BadgePainter extends BoxPainter {
  static const double BASELINE_SHIFT = 1;
  static const double CORNER_RADIUS = 4;
  final Color badgeColor;
  final double badgeSize;
  final TextSpan textSpan;

  _BadgePainter(this.badgeColor, this.badgeSize, this.textSpan);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    canvas.save();
    canvas.translate(
        offset.dx + configuration.size.width - badgeSize, offset.dy);
    canvas.drawPath(buildBadgePath(), getBadgePaint());
    // draw text
    final hyp = math.sqrt(badgeSize * badgeSize + badgeSize * badgeSize);
    final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);
    textPainter.layout(minWidth: hyp, maxWidth: hyp);
    final halfHeight = textPainter.size.height / 2;
    final v = math.sqrt(halfHeight * halfHeight + halfHeight * halfHeight) +
        BASELINE_SHIFT;
    canvas.translate(v, -v);
    canvas.rotate(0.785398); // 45 degrees
    textPainter.paint(canvas, Offset.zero);
    canvas.restore();
  }

  Paint getBadgePaint() => Paint()
    ..isAntiAlias = true
    ..color = badgeColor;

  Path buildBadgePath() => Path.combine(
      PathOperation.difference,
      Path()
        ..addRRect(RRect.fromLTRBAndCorners(0, 0, badgeSize, badgeSize,
            topRight: Radius.circular(CORNER_RADIUS))),
      Path()
        ..lineTo(0, badgeSize)
        ..lineTo(badgeSize, badgeSize)
        ..close());
}

///////////////// cliper

// class MyClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//     // path.lineTo(size.width, 0);
//     // path.close();
//     path.lineTo(-20, size.height);
//     path.lineTo(size.width, size.height);
//     path.close();

//     // path.lineTo(0, size.height - 50);
//     // path.quadraticBezierTo(
//     //     size.width / 2, size.height, size.width, size.height - 50);
//     // path.lineTo(size.width, 0);
//     // path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
// }
