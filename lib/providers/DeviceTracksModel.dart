import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/Userdata.dart';
import '../models/Media.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceTracksModel with ChangeNotifier {
  //List<Comments> _items = [];
  bool isError = false;
  Userdata userdata;
  bool permissionReady = false;
  List<Media> mediaList = [];
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  List<FileSystemEntity> _files;
  List<FileSystemEntity> _songs = [];

  DeviceTracksModel(Userdata userdata) {
    this.mediaList = [];
    this.userdata = userdata;
  }

  loadItems() {
    refreshController.requestRefresh();
    notifyListeners();
    requestPermission();
  }

  void setItems(List<Media> item) {
    mediaList.clear();
    mediaList = item;
    refreshController.refreshCompleted();
    isError = false;
    notifyListeners();
  }

  Future<void> fetchItems() async {
    /*List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    var root = storageInfo[0]
        .rootDir; //storageInfo[1] for SD card, geting the root directory
    var fm = FileManager(root: Directory(root)); //
    List<File> files = await fm.filesTree(
        excludedPaths: ["/storage/emulated/0/Android"],
        extensions: ["mp3"] //optional, to filter files, list only mp3 files
        );
    print(files[0]);*/
    var dirs = (await getApplicationDocumentsDirectory()).path;
    var dir = Directory(dirs);
    //String mp3Path = dir.toString();

    _files = dir.listSync(recursive: true, followLinks: true);
    for (FileSystemEntity entity in _files) {
      String path = entity.path;
      if (path.endsWith('.mp3')) _songs.add(entity);
      print(path);

      //var newString = a.substring(a.lastIndexOf('/'));
      //var newFileName = newString.substring(1);

      //print(newFileName);
    }
  }

  setFetchError() {
    isError = true;
    refreshController.refreshFailed();
    notifyListeners();
  }

  requestPermission() async {
    bool permissionReady = await Permission.storage.request().isGranted;
    if (permissionReady) {
      fetchItems();
    } else {
      setFetchError();
    }
  }
}
