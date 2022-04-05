import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;
import '../models/Artists.dart';
import '../utils/ApiUrl.dart';

class ArtistsModel with ChangeNotifier {
  //List<Comments> _items = [];
  bool isError = false;
  List<Artists> mediaList = [];
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 0;

  ArtistsModel();

  loadItems() {
    refreshController.requestRefresh();
    page = 0;
    fetchItems();
  }

  loadMoreItems() {
    page = page + 1;
    fetchItems();
  }

  void setItems(List<Artists> item) {
    mediaList.clear();
    mediaList = item;
    refreshController.refreshCompleted();
    isError = false;
    notifyListeners();
  }

  void setMoreItems(List<Artists> item) {
    mediaList.addAll(item);
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> fetchItems() async {
    try {
      var data = {"page": page.toString()};
      // print(data);
      final response = await http.post(Uri.parse(ApiUrl.FETCH_ARTISTS),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        //print(response.body);
        //return;

        List<Artists> mediaList =
            await compute(parseSliderMedia, response.body);
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

  static List<Artists> parseSliderMedia(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["artists"].cast<Map<String, dynamic>>();
    return parsed.map<Artists>((json) => Artists.fromJson(json)).toList();
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
