// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GetData with ChangeNotifier {
  List<ListData> data = [];
  GetData() {
    getListData();
  }
  Future getListData() async {
    Uri link = Uri.parse('https://adminapplication.com/fetch_video');
    var response = await http.get(link);
    var jsonData = json.decode(response.body)['videos'];
    // print(jsonData.length);
    for (var u in jsonData) {
      ListData list =
          ListData(u["id"], u["url"], u["thumbnail"], u["artist"], u["title"]);
      data.add(list);
    }
    notifyListeners();
    // return data;
  }
}

class ListData {
  final String id, url, thumbnail, artist, title;
  ListData(this.id, this.url, this.thumbnail, this.artist, this.title);
}
