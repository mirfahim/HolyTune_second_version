class Media {
  final int id, artistId, albumId, genreId;
  int commentsCount, likesCount, previewDuration, duration, viewsCount;
  final String title, coverPhoto, mediaType;
  final String downloadUrl, streamUrl;
  final bool canPreview, canDownload, isFree, http;
  bool userLiked;
  String artist, album, genre, lyrics;

  Media({
    this.id,
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

  static const String BOOKMARKS_TABLE = "bookmarks";
  static const String PLAYLISTS_TABLE = "media_playlists";
  static final bookmarkscolumns = [
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
    "commentsCount",
    "likesCount",
    "previewDuration",
    "streamUrl",
    "viewsCount"
  ];
  static final playlistscolumns = [
    "id",
    "playlistId",
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
    "commentsCount",
    "likesCount",
    "previewDuration",
    "streamUrl",
    "viewsCount"
  ];

  factory Media.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    int artistId = int.parse(json['artist_id'].toString());
    int albumId = int.parse(json['album_id'].toString());
    int genreId = int.parse(json['genre_id'].toString());

    return Media(
        id: id,
        artistId: artistId,
        albumId: albumId,
        genreId: genreId,
        title: json['title'].toString(),
        coverPhoto: json['cover_photo'].toString(),
        mediaType: json['type'].toString(),
        artist: json['artist'].toString(),
        album: json['album'].toString(),
        genre: json['genre'].toString(),
        lyrics: json['lyrics'].toString(),
        downloadUrl: json['download_url'].toString(),
        canPreview: int.parse(json['can_preview'].toString()) == 0,
        canDownload: int.parse(json['can_download'].toString()) == 0,
        isFree: int.parse(json['is_free'].toString()) == 0,
        userLiked:
            bool.fromEnvironment(json['user_liked'].toString().toLowerCase()),
        http: true,
        duration: int.parse(json['duration'].toString()),
        commentsCount: int.parse(json['comments_count'].toString()),
        likesCount: int.parse(json['likes_count'].toString()),
        previewDuration: int.parse(json['preview_duration'].toString()),
        streamUrl: json['stream'].toString(),
        viewsCount: int.parse(json['views_count'].toString()));
  }

  factory Media.fromMap(Map<String, dynamic> data) {
    return Media(
      id: data['id'],
      artistId: data['artistId'],
      albumId: data['albumId'],
      genreId: data['genreId'],
      title: data['title'],
      coverPhoto: data['cover_photo'],
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
