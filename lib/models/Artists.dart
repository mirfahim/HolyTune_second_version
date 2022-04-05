class Artists {
  final int id;
  final String title;
  final String thumbnail;
  final String biography;
  final int mediaCount, albumCount;

  Artists(
      {this.id,
      this.title,
      this.thumbnail,
      this.mediaCount,
      this.albumCount,
      this.biography});

  factory Artists.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    int count = int.parse(json['media_count'].toString());
    int _albumcount = int.parse(json['album_count'].toString());

    return Artists(
      id: id,
      title: json['name'] as String,
      thumbnail: json['thumbnail'] as String,
      mediaCount: count,
      albumCount: _albumcount,
      biography: json['biography'] as String,
    );
  }
}
