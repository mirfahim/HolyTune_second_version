import 'package:HolyTune/providers/AppStateNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../screens/MoodsMediaScreen.dart';
import '../screens/MoodsScreen.dart';
import '../utils/TextStyles.dart';
import '../models/Moods.dart';
import '../i18n/strings.g.dart';
import '../models/ScreenArguements.dart';

class MoodsListView extends StatelessWidget {
  MoodsListView(this.moods);
  final List<Moods> moods;
  AppStateNotifier appState;
  Widget _buildItems(BuildContext context, int index) {
    appState = Provider.of<AppStateNotifier>(context);
    var cats = moods[index];

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
                width: 100,
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
                        child: Icon(
                      Icons.error,
                      color: Colors.grey,
                    )),
                  ),
                ),
              ),
              SizedBox(height: 7.0),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  cats.title,
                  style: TextStyles.headline(context).copyWith(
                    //fontWeight: FontWeight.bold,
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
                  style: TextStyles.subhead(context).copyWith(
                    //fontWeight: FontWeight.bold,
                    fontSize: 11.0,

                    color: appState.isDarkModeOn == false
                        ? Color.fromARGB(255, 255, 255, 255)
                        : Colors.white54,
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
              child: Text(t.moods,
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
                  MoodsScreen.routeName,
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
          height: 170.0,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            primary: false,
            itemCount: moods.length,
            itemBuilder: _buildItems,
          ),
        ),
      ],
    );
  }
}
