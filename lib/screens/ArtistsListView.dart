import 'package:HolyTune/providers/AppStateNotifier.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../screens/ArtistsScreen.dart';
import '../utils/TextStyles.dart';
import '../models/Artists.dart';
import '../i18n/strings.g.dart';
import '../models/ScreenArguements.dart';
import '../screens/ArtistProfileScreen.dart';

class ArtistsListView extends StatelessWidget {
  AppStateNotifier appState;

  ArtistsListView(this.artists);

  final List<Artists> artists;

  Widget _buildItems(BuildContext context, int index) {
    var cats = artists[index];
    appState = Provider.of<AppStateNotifier>(context);
    // print("object");
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: InkWell(
        child: SizedBox(
          height: 100.0,
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
                    imageBuilder: (context, imageProvider) {
                      // print(cats.thumbnail);
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Center(
                      child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage(
                            "assets/images/holy_tune_logo_512_blue_bg.png"),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 7.0),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  cats.title,
                  style: TextStyles.headline(context).copyWith(
                    fontWeight: FontWeight.bold,
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
                      ? TextStyles.subhead(context).copyWith(
                          //fontWeight: FontWeight.bold,
                          fontSize: 11.0,
                          color: Color.fromARGB(255, 250, 248, 248),
                        )
                      : TextStyles.subhead(context).copyWith(
                          //fontWeight: FontWeight.bold,
                          fontSize: 11.0,
                          color: Color.fromARGB(220, 251, 251, 251),
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
            ArtistProfileScreen.routeName,
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
              child: Text(t.artists,
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
                  ArtistsScreen.routeName,
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
            itemCount: artists.length,
            itemBuilder: _buildItems,
          ),
        ),
      ],
    );
  }
}
