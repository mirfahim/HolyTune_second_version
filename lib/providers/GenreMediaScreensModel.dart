import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../database/SQLiteDbProvider.dart';
import 'package:http/http.dart' as http;
import '../models/Genres.dart';
import '../utils/ApiUrl.dart';
import '../models/Userdata.dart';
import '../models/Media.dart';

class GenreMediaScreensModel with ChangeNotifier {
  //List<Comments> _items = [];
  bool isError = false;
  Userdata userdata;
  List<Media> mediaList = [];
  List<Genres> genresList = [];
  int selectedGenre = 0;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 0;

  GenreMediaScreensModel(this.genresList) {
    this.mediaList = [];
    if (genresList.length > 0) {
      selectedGenre = genresList[0].id;
    }
    getUserData();
  }

  getUserData() async {
    userdata = await SQLiteDbProvider.db.getUserData();
    print("userdata " + userdata.toString());
    notifyListeners();
  }

  loadItems() {
    if (selectedGenre == 0 && genresList.length > 0) {
      selectedGenre = genresList[0].id;
    }
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

  bool isGenreSelected(int index) {
    Genres genres = genresList[index];
    return genres.id == selectedGenre;
  }

  refreshPageOnGenreSelected(int id) {
    if (id != selectedGenre) {
      page = 0;
      selectedGenre = id;
      notifyListeners();
      loadItems();
    }
  }

  Future<void> fetchItems() async {
    try {
      var data = {
        "email": userdata == null ? "null" : userdata.email,
        "genre": selectedGenre.toString(),
        "version": "v2",
        "page": page.toString()
      };
      print(data);
      final response = await http.post(Uri.parse(ApiUrl.GENRE_MEDIA),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {


        // If the server did return a 200 OK response,
        // then parse the JSON.

        List<Media> mediaList = await compute(parseSliderMedia, response.body);
        if (page == 0) {
          setItems(mediaList);
          print("MY MEDIA DATA IS FROM ApiUrl.GENRE_MEDIA free ${mediaList[0].isFree}");
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
