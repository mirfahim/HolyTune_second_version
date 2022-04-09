import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/MoodsMediaScreen.dart';
import '../utils/Utility.dart';
import '../i18n/strings.g.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/Moods.dart';
import '../providers/MoodsModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../screens/NoitemScreen.dart';
import '../utils/TextStyles.dart';
import '../models/ScreenArguements.dart';

class MoodsDrawerScreen extends StatefulWidget {
  MoodsDrawerScreen();

  @override
  _CategoriesMediaScreenState createState() => _CategoriesMediaScreenState();
}

class _CategoriesMediaScreenState extends State<MoodsDrawerScreen> {
  MoodsModel mediaScreensModel;
  List<Moods> items;

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
      Provider.of<MoodsModel>(context, listen: false).loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    mediaScreensModel = Provider.of<MoodsModel>(context);
    items = mediaScreensModel.moodsList;

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
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
              child: Text(t.moods,
                  style: TextStyles.headline(context).copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  )),
            ),
          ),
          Expanded(
            child: (mediaScreensModel.isError == true && items.length == 0)
                ? NoitemScreen(
                    title: t.oops,
                    message: t.dataloaderror,
                    onClick: _onRefresh)
                : GridView.builder(
                    shrinkWrap: false,
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.all(3),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2.0,
                        mainAxisSpacing: 0.0,
                        childAspectRatio: 1.1),
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ItemTile(
                        index: index,
                        moods: items[index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ItemTile extends StatelessWidget {
  final Moods moods;
  final int index;

  const ItemTile({
    Key key,
    @required this.index,
    @required this.moods,
  })  : assert(index != null),
        assert(moods != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: InkWell(
        child: Container(
          // height: 200.0,
          width: 120.0,
          child: Column(
            children: <Widget>[
              Container(
                height: 120,
                //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    // height: 180,
                    imageUrl: moods.thumbnail,
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
                  moods.title,
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
                  (moods.mediaCount == 0
                          ? "0"
                          : Utility.formatNumber(moods.mediaCount)) +
                      " " +
                      t.tracks,
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
            MoodsMediaScreen.routeName,
            arguments: ScreenArguements(position: 0, items: moods),
          );
        },
      ),
    );
  }
}
