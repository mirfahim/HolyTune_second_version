import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../database/SQLiteDbProvider.dart';
import 'package:http/http.dart' as http;
import '../models/Artists.dart';
import '../utils/ApiUrl.dart';
import '../models/Userdata.dart';
import '../models/Media.dart';

class ArtistsMediaModel with ChangeNotifier {
  bool isError = false;
  Userdata userdata;
  List<Media> mediaList = [];
  Artists artists;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 0;

  ArtistsMediaModel(Artists artists) {
    this.mediaList = [];
    this.artists = artists;
    getUserData();
  }

  getUserData() async {
    userdata = await SQLiteDbProvider.db.getUserData();
    print("userdata " + userdata.toString());
    notifyListeners();
  }

  loadItems() {
    refreshController.requestRefresh();
    page = 0;
    fetchItems();
  }

  loadMoreItems() {
    page = page + 1;
    fetchItems();
  }

  void setItems(List<Media> item) {
    mediaList.clear();
    mediaList = item;
    refreshController.refreshCompleted();
    isError = false;

    notifyListeners();
  }

  void setMoreItems(List<Media> item) {
    mediaList.addAll(item);
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> fetchItems() async {
    print("++++++++++++++++++my all data from fetch_media api ++++++++++++++++++++++++++++++++++++");
    try {
      var data = {
        "email": userdata == null ? "null" : userdata.email,
        "artist": artists.id.toString(), //2
        "version": "v2",
        "page": page.toString() //0
      };
      print(data);
      final response = await http.post(Uri.parse(ApiUrl.FETCH_MEDIA),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print("+++++++++200+++++++++my all data from fetch_media api +++++++++++++++++++++200+++++++++++++++");
        List<Media> mediaList = await compute(parseSliderMedia, response.body);
        if (page == 0) {
          setItems(mediaList);
          print("my midea list is free ${mediaList[0].isFree}");
        } else {
          setMoreItems(mediaList);
        }
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

  static List<Media> parseSliderMedia(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["media"].cast<Map<String, dynamic>>();
    return parsed.map<Media>((json) => Media.fromJson(json)).toList();
  }

  setFetchError() {
    if (page == 0) {
      isError = true;
      refreshController.refreshFailed();
      notifyListeners();
    } else {
      refreshController.loadFailed();
      notifyListeners();
    }
  }
}
