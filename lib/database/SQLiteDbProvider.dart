import 'dart:async';
import '../models/Categories.dart';
import '../models/Userdata.dart';
import 'package:path/path.dart';
import '../models/Media.dart';
import '../models/Playlists.dart';
import '../models/Downloads.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteDbProvider {
  SQLiteDbProvider._();
  static final SQLiteDbProvider db = SQLiteDbProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(
        join(await getDatabasesPath(), 'streamit_database.db'),
        version: 1,
        onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE ${Categories.TABLE} ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "thumbnailUrl TEXT"
          ")");

      await db.execute("CREATE TABLE ${Playlists.TABLE} ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "title TEXT,"
          "type TEXT"
          ")");

      await db.execute("CREATE TABLE ${Media.BOOKMARKS_TABLE} ("
          "id INTEGER PRIMARY KEY,"
          "artistId INTEGER,"
          "albumId INTEGER,"
          "genreId INTEGER,"
          "title TEXT,"
          "coverPhoto TEXT,"
          "mediaType TEXT,"
          "artist TEXT,"
          "album TEXT,"
          "genre TEXT,"
          "lyrics TEXT,"
          "downloadUrl TEXT,"
          "canPreview INTEGER,"
          "canDownload INTEGER,"
          "isFree INTEGER,"
          "userLiked INTEGER,"
          "http INTEGER,"
          "duration INTEGER,"
          "commentsCount INTEGER,"
          "likesCount INTEGER,"
          "previewDuration INTEGER,"
          "streamUrl TEXT,"
          "viewsCount INTEGER"
          ")");

      await db.execute("CREATE TABLE ${Media.PLAYLISTS_TABLE} ("
          "id INTEGER,"
          "playlistId INTEGER,"
          "artistId INTEGER,"
          "albumId INTEGER,"
          "genreId INTEGER,"
          "title TEXT,"
          "coverPhoto TEXT,"
          "mediaType TEXT,"
          "artist TEXT,"
          "album TEXT,"
          "genre TEXT,"
          "lyrics TEXT,"
          "downloadUrl TEXT,"
          "canPreview INTEGER,"
          "canDownload INTEGER,"
          "isFree INTEGER,"
          "userLiked INTEGER,"
          "http INTEGER,"
          "duration INTEGER,"
          "commentsCount INTEGER,"
          "likesCount INTEGER,"
          "previewDuration INTEGER,"
          "streamUrl TEXT,"
          "viewsCount INTEGER"
          ")");

      await db.execute("CREATE TABLE ${Downloads.Downloads_TABLE} ("
          "id INTEGER PRIMARY KEY,"
          "artistId INTEGER,"
          "albumId INTEGER,"
          "genreId INTEGER,"
          "title TEXT,"
          "coverPhoto TEXT,"
          "mediaType TEXT,"
          "artist TEXT,"
          "album TEXT,"
          "genre TEXT,"
          "lyrics TEXT,"
          "downloadUrl TEXT,"
          "canPreview INTEGER,"
          "canDownload INTEGER,"
          "isFree INTEGER,"
          "userLiked INTEGER,"
          "http INTEGER,"
          "duration INTEGER,"
          "timeStamp INTEGER,"
          "progress INTEGER,"
          "taskId TEXT,"
          "commentsCount INTEGER,"
          "likesCount INTEGER,"
          "previewDuration INTEGER,"
          "streamUrl TEXT,"
          "viewsCount INTEGER"
          ")");

      await db.execute("CREATE TABLE ${Userdata.TABLE} ("
          "email TEXT,"
          "name TEXT"
          ")");
    });
  }

  //userdata crud
  Future<Userdata> getUserData() async {
    final db = await database;
    List<Map> results = await db.query(
      "${Userdata.TABLE}",
      columns: Userdata.columns,
    );
    print(results.toString());
    List<Userdata> userdatalist = [];
    results.forEach((result) {
      Userdata userdata = Userdata.fromMap(result);
      userdatalist.add(userdata);
    });
    //print(categories.length);
    return userdatalist.length > 0 ? userdatalist[0] : null;
  }

  insertUser(Userdata userdata) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT Into ${Userdata.TABLE} (email, name)"
        " VALUES (?, ?)",
        [userdata.email, userdata.name]);
    return result;
  }

  deleteUserData() async {
    final db = await database;
    db.rawDelete("DELETE FROM ${Userdata.TABLE}");
  }

  //categories crud
  Future<List<Categories>> getAllCategories() async {
    final db = await database;
    List<Map> results = await db.query("${Categories.TABLE}",
        columns: Categories.columns, orderBy: "id ASC");
    List<Categories> categories = [];
    results.forEach((result) {
      Categories category = Categories.fromMap(result);
      categories.add(category);
    });
    //print(categories.length);
    return categories;
  }

  insertCategory(Categories categories) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT OR REPLACE Into ${Categories.TABLE} (id, title, thumbnailUrl)"
        " VALUES (?, ?, ?)",
        [categories.id, categories.title, categories.thumbnailUrl]);
    return result;
  }

  deleteCategory(int id) async {
    final db = await database;
    db.delete("${Categories.TABLE}", where: "id = ?", whereArgs: [id]);
  }

  //media bookmarks crud
  Future<List<Media>> getAllMediaBookmarks() async {
    final db = await database;
    List<Map> results = await db.query("${Media.BOOKMARKS_TABLE}",
        columns: Media.bookmarkscolumns);
    List<Media> medialist = [];
    results.forEach((result) {
      Media media = Media.fromMap(result);
      medialist.add(media);
    });
    print(medialist.length);
    return medialist;
  }

  bookmarkMedia(Media media) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT OR REPLACE Into ${Media.BOOKMARKS_TABLE} (id,artistId,albumId,genreId,title,coverPhoto,mediaType,artist,album,genre,lyrics,downloadUrl,canPreview,canDownload,isFree,userLiked,http, duration,commentsCount,likesCount,previewDuration,streamUrl,viewsCount)"
        " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?)",
        [
          media.id,
          media.artistId,
          media.albumId,
          media.genreId,
          media.title,
          media.coverPhoto,
          media.mediaType,
          media.artist,
          media.album,
          media.genre,
          media.lyrics,
          media.downloadUrl,
          media.canPreview == true ? 0 : 1,
          media.canDownload == true ? 0 : 1,
          media.isFree == true ? 0 : 1,
          media.userLiked == true ? 0 : 1,
          media.http == true ? 0 : 1,
          media.duration,
          media.commentsCount,
          media.likesCount,
          media.previewDuration,
          media.streamUrl,
          media.viewsCount
        ]);
    return result;
  }

  //userdata crud
  Future<bool> isMediaBookmarked(Media media) async {
    final db = await database;
    List<Map> results = await db.query("${Media.BOOKMARKS_TABLE}",
        columns: Media.bookmarkscolumns,
        where: "id = ?",
        whereArgs: [media.id]);
    return results.length > 0;
  }

  deleteBookmarkedMedia(int id) async {
    final db = await database;
    db.delete("${Media.BOOKMARKS_TABLE}", where: "id = ?", whereArgs: [id]);
  }

//playlists crud
  Future<List<Playlists>> getAllPlaylists() async {
    final db = await database;
    List<Map> results =
        await db.query("${Playlists.TABLE}", columns: Playlists.columns);
    List<Playlists> playlists = [];
    results.forEach((result) {
      Playlists playlist = Playlists.fromMap(result);
      playlists.add(playlist);
    });
    //print(categories.length);
    return playlists;
  }

  newPlaylist(String title, String type) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT OR REPLACE Into ${Playlists.TABLE} (title, type)"
        " VALUES (?, ?)",
        [title, type]);
    return result;
  }

  deletePlaylist(int id) async {
    final db = await database;
    db.delete("${Playlists.TABLE}", where: "id = ?", whereArgs: [id]);
  }

  //media playlists crud
  Future<List<Media>> getAllPlaylistsMedia(int playlistid) async {
    final db = await database;
    List<Map> results = await db.query("${Media.PLAYLISTS_TABLE}",
        columns: Media.playlistscolumns,
        where: "playlistId = ?",
        whereArgs: [playlistid]);
    List<Media> medialist = [];
    results.forEach((result) {
      Media media = Media.fromMap(result);
      medialist.add(media);
    });
    //print(categories.length);
    return medialist;
  }

  Future<int> getPlaylistsMediaCount(int playlistid) async {
    final db = await database;
    List<Map> results = await db.query("${Media.PLAYLISTS_TABLE}",
        columns: Media.playlistscolumns,
        where: "playlistId = ?",
        whereArgs: [playlistid]);
    List<Media> medialist = [];
    results.forEach((result) {
      Media media = Media.fromMap(result);
      medialist.add(media);
    });
    //print(categories.length);
    return medialist.length;
  }

  Future<String> getPlayListFirstMediaThumbnail(int playlistid) async {
    final db = await database;
    List<Map> results = await db.query("${Media.PLAYLISTS_TABLE}",
        columns: Media.playlistscolumns,
        where: "playlistId = ?",
        whereArgs: [playlistid]);
    List<Media> medialist = [];
    results.forEach((result) {
      Media media = Media.fromMap(result);
      medialist.add(media);
    });
    if (medialist.length > 0) {
      return medialist[0].coverPhoto;
    }
    //print(categories.length);
    return "";
  }

  addMediaToPlaylists(Media media, int playlistid) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT OR REPLACE Into ${Media.PLAYLISTS_TABLE} (id, playlistId,artistId,albumId,genreId,title,coverPhoto,mediaType,artist,album,genre,lyrics,downloadUrl,canPreview,canDownload,isFree,userLiked,http, duration,commentsCount,likesCount,previewDuration,streamUrl,viewsCount)"
        " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?)",
        [
          media.id,
          playlistid,
          media.artistId,
          media.albumId,
          media.genreId,
          media.title,
          media.coverPhoto,
          media.mediaType,
          media.artist,
          media.album,
          media.genre,
          media.lyrics,
          media.downloadUrl,
          media.canPreview == true ? 0 : 1,
          media.canDownload == true ? 0 : 1,
          media.isFree == true ? 0 : 1,
          media.userLiked == true ? 0 : 1,
          media.http == true ? 0 : 1,
          media.duration,
          media.commentsCount,
          media.likesCount,
          media.previewDuration,
          media.streamUrl,
          media.viewsCount
        ]);
    return result;
  }

  //userdata crud
  Future<bool> isMediaAddedToPlaylist(Media media, int playlistid) async {
    final db = await database;
    List<Map> results = await db.query("${Media.PLAYLISTS_TABLE}",
        columns: Media.playlistscolumns,
        where: "id = ? AND playlistId = ?",
        whereArgs: [media.id, playlistid]);
    return results.length > 0;
  }

  deletePlaylistsMedia(int playlistid) async {
    final db = await database;
    db.delete("${Media.PLAYLISTS_TABLE}",
        where: "playlistId = ?", whereArgs: [playlistid]);
  }

  removeMediaFromPlaylist(Media media, int playlistid) async {
    final db = await database;
    db.delete("${Media.PLAYLISTS_TABLE}",
        where: "id = ? AND playlistId = ?", whereArgs: [media.id, playlistid]);
  }

  //downloads list crud
  Future<List<Downloads>> getAllDownloads() async {
    final db = await database;
    List<Map> results = await db.query("${Downloads.Downloads_TABLE}",
        columns: Downloads.downloadscolumns, orderBy: "timeStamp Desc");
    List<Downloads> medialist = [];
    results.forEach((result) {
      Downloads media = Downloads.fromMap(result);
      medialist.add(media);
    });
    //print(categories.length);
    return medialist;
  }

  addNewDownloadItem(Downloads media) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT OR IGNORE Into ${Downloads.Downloads_TABLE} (id,artistId,albumId,genreId,title,coverPhoto,mediaType,artist,album,genre,lyrics,downloadUrl,canPreview,canDownload,isFree,userLiked,http, duration,timeStamp,progress,taskId,commentsCount,likesCount,previewDuration,streamUrl,viewsCount)"
        " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?)",
        [
          media.id,
          media.artistId,
          media.albumId,
          media.genreId,
          media.title,
          media.coverPhoto,
          media.mediaType,
          media.artist,
          media.album,
          media.genre,
          media.lyrics,
          media.downloadUrl,
          media.canPreview == true ? 0 : 1,
          media.canDownload == true ? 0 : 1,
          media.isFree == true ? 0 : 1,
          media.userLiked == true ? 0 : 1,
          media.http == true ? 0 : 1,
          media.duration,
          media.timeStamp,
          media.progress,
          media.taskId,
          media.commentsCount,
          media.likesCount,
          media.previewDuration,
          media.streamUrl,
          media.viewsCount
        ]);
    return result;
  }

  deleteDownloadMedia(int id) async {
    final db = await database;
    db.delete("${Downloads.Downloads_TABLE}", where: "id = ?", whereArgs: [id]);
  }
}
