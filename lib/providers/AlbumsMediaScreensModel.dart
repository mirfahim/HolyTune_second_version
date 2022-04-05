import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../database/SQLiteDbProvider.dart';
import 'package:http/http.dart' as http;
import '../models/Albums.dart';
import '../utils/ApiUrl.dart';
import '../models/Userdata.dart';
import '../models/Media.dart';

class AlbumsMediaScreensModel with ChangeNotifier {
  //List<Comments> _items = [];
  bool isError = false;
  Userdata userdata;
  List<Media> mediaList = [];
  Albums albums;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 0;
  int albumDuration = 0;

  AlbumsMediaScreensModel(this.albums) {
    this.mediaList = [];
    this.albums = albums;
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
    albumDuration = 0;
    item.forEach((element) {
      albumDuration += element.duration;
    });
    notifyListeners();
  }

  void setMoreItems(List<Media> item) {
    mediaList.addAll(item);
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> fetchItems() async {
    print("HLW BRPOOOO");
    try {
      var data = {
        "email": userdata == null ? "null" : userdata.email,
        "album": albums.id.toString(),
        "version": "v2",
        "page": page.toString()
      };
      print(data);
      print("HLW BROOOO");
      final response = await http.post(Uri.parse(ApiUrl.FETCH_ALBUM_MEDIA),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.statusCode);
        List<Media> mediaList = await compute(parseSliderMedia, response.body);
        if (page == 0) {
          setItems(mediaList);
          print(response.body);
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
