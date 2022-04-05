import 'package:flutter_downloader/flutter_downloader.dart';
import '../models/Media.dart';

class Downloads {
  final int id, artistId, albumId, genreId;
  int commentsCount, likesCount, previewDuration, duration, viewsCount;
  final String category, title, coverPhoto, mediaType;
  String downloadUrl, streamUrl;
  final bool canPreview, canDownload, isFree, http;
  bool userLiked;
  int progress = 0;
  int timeStamp = 0;
  String taskId = "";
  String artist, album, genre, lyrics;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  Downloads({
    this.id,
    this.category,
    this.title,
    this.coverPhoto,
    this.mediaType,
    this.downloadUrl,
    this.canPreview,
    this.canDownload,
    this.isFree,
    this.userLiked,
    this.http,
    this.duration,
    this.timeStamp,
    this.progress,
    this.taskId,
    this.commentsCount,
    this.likesCount,
    this.previewDuration,
    this.streamUrl,
    this.viewsCount,
    this.artistId,
    this.albumId,
    this.genreId,
    this.artist,
    this.album,
    this.genre,
    this.lyrics,
  });

  static const String Downloads_TABLE = "downloads";
  static final downloadscolumns = [
    "id",
    "artistId",
    "albumId",
    "genreId",
    "title",
    "coverPhoto",
    "mediaType",
    "artist",
    "album",
    "genre",
    "lyrics",
    "downloadUrl",
    "canPreview",
    "canDownload",
    "isFree",
    "userLiked",
    "http",
    "duration",
    "timeStamp",
    "progress",
    "taskId",
    "commentsCount",
    "likesCount",
    "previewDuration",
    "streamUrl",
    "viewsCount"
  ];

  factory Downloads.fromMap(Map<String, dynamic> data) {
    return Downloads(
      id: data['id'],
      artistId: data['artistId'],
      albumId: data['albumId'],
      genreId: data['genreId'],
      title: data['title'],
      coverPhoto: data['coverPhoto'],
      mediaType: data['mediaType'],
      artist: data['artist'],
      album: data['album'],
      genre: data['genre'],
      lyrics: data['lyrics'],
      downloadUrl: data['downloadUrl'],
      canPreview: int.parse(data['canPreview'].toString()) == 0,
      canDownload: int.parse(data['canDownload'].toString()) == 0,
      isFree: int.parse(data['isFree'].toString()) == 0,
      userLiked: int.parse(data['userLiked'].toString()) == 0,
      http: int.parse(data['http'].toString()) == 0,
      duration: data['duration'],
      commentsCount: data['commentsCount'],
      likesCount: data['likesCount'],
      previewDuration: data['previewDuration'],
      streamUrl: data['streamUrl'],
      viewsCount: data['viewsCount'],
    );
  }

  static mapCurrentDownloadMedia(Media media) {
    return Downloads(
      id: media.id,
      artistId: media.artistId,
      albumId: media.albumId,
      genreId: media.genreId,
      title: media.title,
      coverPhoto: media.coverPhoto,
      mediaType: media.mediaType,
      artist: media.artist,
      album: media.album,
      genre: media.genre,
      lyrics: media.lyrics,
      downloadUrl: media.streamUrl,
      canPreview: true,
      canDownload: false,
      isFree: true,
      userLiked: media.userLiked,
      http: false,
      duration: media.duration,
      timeStamp: new DateTime.now().microsecondsSinceEpoch,
      progress: 0,
      taskId: "",
      commentsCount: media.commentsCount,
      likesCount: media.likesCount,
      previewDuration: media.previewDuration,
      streamUrl: media.streamUrl,
      viewsCount: media.viewsCount,
    );
  }

  static Media mapMediaFromDownload(Downloads media) {
    return Media(
      id: media.id,
      artistId: media.artistId,
      albumId: media.albumId,
      genreId: media.genreId,
      title: media.title,
      coverPhoto: media.coverPhoto,
      mediaType: media.mediaType,
      artist: media.artist,
      album: media.album,
      genre: media.genre,
      lyrics: media.lyrics,
      downloadUrl: media.downloadUrl,
      canPreview: true,
      canDownload: false,
      isFree: true,
      userLiked: media.userLiked,
      http: false,
      duration: media.duration,
      commentsCount: media.commentsCount,
      likesCount: media.likesCount,
      previewDuration: media.previewDuration,
      streamUrl: media.streamUrl,
      viewsCount: media.viewsCount,
    );
  }

  static List<Media> mapMediaListFromDownloadList(
      List<Downloads> downloadsList) {
    List<Media> mediaList = [];
    for (var media in downloadsList) {
      mediaList.add(Media(
        id: media.id,
        artistId: media.artistId,
        albumId: media.albumId,
        genreId: media.genreId,
        title: media.title,
        coverPhoto: media.coverPhoto,
        mediaType: media.mediaType,
        artist: media.artist,
        album: media.album,
        genre: media.genre,
        lyrics: media.lyrics,
        downloadUrl: media.downloadUrl,
        canPreview: true,
        canDownload: false,
        isFree: true,
        userLiked: media.userLiked,
        http: false,
        duration: media.duration,
        commentsCount: media.commentsCount,
        likesCount: media.likesCount,
        previewDuration: media.previewDuration,
        streamUrl: media.streamUrl,
        viewsCount: media.viewsCount,
      ));
    }
    return mediaList;
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "artistId": artistId,
        "albumId": albumId,
        "genreId": genreId,
        "title": title,
        "coverPhoto": coverPhoto,
        "mediaType": mediaType,
        "artist": artist,
        "album": album,
        "genre": genre,
        "lyrics": lyrics,
        "downloadUrl": downloadUrl,
        "canPreview": canPreview,
        "canDownload": canDownload,
        "isFree": isFree,
        "userLiked": userLiked,
        "http": http,
        "duration": duration,
        "commentsCount": commentsCount,
        "likesCount": likesCount,
        "previewDuration": previewDuration,
        "streamUrl": streamUrl,
        "viewsCount": viewsCount
      };
}
