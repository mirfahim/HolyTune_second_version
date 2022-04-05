import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;
import '../models/Moods.dart';
import '../utils/ApiUrl.dart';

class MoodsModel with ChangeNotifier {
  //List<Comments> _items = [];
  bool isError = false;
  List<Moods> moodsList = [];
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 0;

  MoodsModel();

  loadItems() {
    refreshController.requestRefresh();
    page = 0;
    fetchItems();
  }

  loadMoreItems() {
    page = page + 1;
    fetchItems();
  }

  void setItems(List<Moods> item) {
    moodsList.clear();
    moodsList = item;
    refreshController.refreshCompleted();
    isError = false;
    notifyListeners();
  }

  void setMoreItems(List<Moods> item) {
    moodsList.addAll(item);
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> fetchItems() async {
    try {
      var data = {"page": page.toString()};
      print(data);
      final response = await http.post(Uri.parse(ApiUrl.FETCH_MOODS),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        List<Moods> mediaList = await compute(parseSliderMedia, response.body);
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

  static List<Moods> parseSliderMedia(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["moods"].cast<Map<String, dynamic>>();
    return parsed.map<Moods>((json) => Moods.fromJson(json)).toList();
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
