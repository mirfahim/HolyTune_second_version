class Albums {
  final int id;
  final String title, artist;
  final String thumbnail, artistAvatar;
  final int mediaCount;

  Albums(
      {this.id,
      this.title,
      this.thumbnail,
      this.mediaCount,
      this.artist,
      this.artistAvatar});

  factory Albums.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    int count = int.parse(json['media_count'].toString());
    return Albums(
        id: id,
        title: json['name'] as String,
        thumbnail: json['thumbnail'] as String,
        mediaCount: count,
        artist: json['artist'] as String,
        artistAvatar: json['artist_avatar'] as String);
  }
}
