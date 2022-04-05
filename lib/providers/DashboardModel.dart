import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:HolyTune/models/ScreenArguements.dart';
import 'package:HolyTune/screens/GenresMediaScreen.dart';
import '../i18n/strings.g.dart';
import '../utils/ApiUrl.dart';
import '../models/Userdata.dart';
import '../models/Media.dart';
import '../models/Albums.dart';
import '../models/Artists.dart';
import '../models/Genres.dart';
import '../models/Moods.dart';

class DashboardModel with ChangeNotifier {
  //List<Comments> _items = [];
  bool isError = false;
  Userdata userdata;
  bool isLoading = false;
  List<Albums> albums;
  List<Artists> artists;
  List<Moods> moods;
  List<Genres> genres;
  List<Media> sliderMedias;
  List<Media> latestAudios;
  List<Media> trendingAudios;
  List<Widget> chipsWidgets = [];
  BuildContext context;

  DashboardModel(this.context, Userdata userdata) {
    this.userdata = userdata;
    loadItems();
  }

  loadItems() {
    isLoading = true;
    notifyListeners();
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      final dio = Dio();
      // Adding an interceptor to enable caching.

      final response = await dio.post(
        ApiUrl.DISCOVER,
        data: jsonEncode({
          "data": {
            "email": userdata == null ? "null" : userdata.email,
            "version": "v2"
          }
        }),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        isLoading = false;
        isError = false;

        dynamic res = jsonDecode(response.data);
        moods = parseMoods(res);
        albums = parseAlbums(res);
        artists = parseArtists(res);
        sliderMedias = parseSliderMedia(res);
        genres = parseGenres(res);
        latestAudios = parseLatestAudios(res);
        trendingAudios = parseTrendingAudios(res);
        print("sliderMedias" + sliderMedias.toString());

        for (int i = 0; (i < genres.length && i < 7); i++) {
          chipsWidgets.add(getChip(genres[i]));
        }
        chipsWidgets
            .add(getChip(Genres(id: 0, title: t.genres, mediaCount: 0)));
        notifyListeners();
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        setFetchError();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      setFetchError();
    }
  }

  static List<Moods> parseMoods(dynamic res) {
    final parsed = res["moods"].cast<Map<String, dynamic>>();
    return parsed.map<Moods>((json) => Moods.fromJson(json)).toList();
  }

  static List<Albums> parseAlbums(dynamic res) {
    final parsed = res["albums"].cast<Map<String, dynamic>>();
    return parsed.map<Albums>((json) => Albums.fromJson(json)).toList();
  }

  static List<Artists> parseArtists(dynamic res) {
    final parsed = res["artists"].cast<Map<String, dynamic>>();
    return parsed.map<Artists>((json) => Artists.fromJson(json)).toList();
  }

  static List<Genres> parseGenres(dynamic res) {
    final parsed = res["genres"].cast<Map<String, dynamic>>();
    return parsed.map<Genres>((json) => Genres.fromJson(json)).toList();
  }

  static List<Media> parseSliderMedia(dynamic res) {
    final parsed = res["slider_media"].cast<Map<String, dynamic>>();
    print("CHECK_______HERE____________");
    print(parsed);
    return parsed.map<Media>((json) => Media.fromJson(json)).toList();
  }

  static List<Media> parseLatestAudios(dynamic res) {
    final parsed = res["latest_audios"].cast<Map<String, dynamic>>();
    return parsed.map<Media>((json) => Media.fromJson(json)).toList();
  }

  static List<Media> parseTrendingAudios(dynamic res) {
    final parsed = res["trending_audios"].cast<Map<String, dynamic>>();
    return parsed.map<Media>((json) => Media.fromJson(json)).toList();
  }

  setFetchError() {
    isError = true;
    isLoading = false;
    notifyListeners();
  }

  Widget getChip(Genres genre) {
    return /*ActionChip(
      elevation: 8.0,
      padding: EdgeInsets.all(0.0),
      avatar: CircleAvatar(
        backgroundColor: MyColors.accent,
        child: Icon(
          LineAwesomeIcons.music,
          color: Colors.white,
          size: 20,
        ),
      ),
      label: Text(label),
      onPressed: () {},
      backgroundColor: Colors.grey[700],
      shape: StadiumBorder(
          side: BorderSide(
        width: 1,
        color: MyColors.accent,
      )),
    );*/

        InkWell(
      onTap: () {
        List<Genres> _genres = [];
        _genres.add(genre);
        Navigator.pushNamed(
          context,
          GenresMediaScreen.routeName,
          arguments: ScreenArguements(
              position: 0, itemsList: genre.id == 0 ? this.genres : _genres),
        );
      },
      child: Chip(
        labelPadding: EdgeInsets.all(2.0),
        avatar: Icon(
          Icons.multitrack_audio,
          color: Colors.white,
        ),
        label: Text(
          genre.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
        backgroundColor: Colors.grey[600],
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
      ),
    );
  }
}
