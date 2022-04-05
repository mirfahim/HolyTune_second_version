import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;
import '../models/Albums.dart';
import '../utils/ApiUrl.dart';

class AlbumsModel with ChangeNotifier {
  //List<Comments> _items = [];
  bool isError = false;
  List<Albums> mediaList = [];
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 0;

  AlbumsModel();

  loadItems() {
    refreshController.requestRefresh();
    page = 0;
    fetchItems();
  }

  loadMoreItems() {
    page = page + 1;
    fetchItems();
  }

  void setItems(List<Albums> item) {
    mediaList.clear();
    mediaList = item;
    refreshController.refreshCompleted();
    isError = false;
    notifyListeners();
  }

  void setMoreItems(List<Albums> item) {
    mediaList.addAll(item);
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> fetchItems() async {
    try {
      var data = {"page": page.toString()};
      print(data);
      final response = await http.post(Uri.parse(ApiUrl.FETCH_ALBUMS),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        List<Albums> mediaList = await compute(parseSliderMedia, response.body);
        if (page == 0) {
          setItems(mediaList);
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

  static List<Albums> parseSliderMedia(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["albums"].cast<Map<String, dynamic>>();
    return parsed.map<Albums>((json) => Albums.fromJson(json)).toList();
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
