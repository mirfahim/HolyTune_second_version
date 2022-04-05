class Moods {
  final int id;
  final String title;
  final String thumbnail;
  final int mediaCount;

  Moods({
    this.id,
    this.title,
    this.thumbnail,
    this.mediaCount,
  });

  factory Moods.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    int count = int.parse(json['media_count'].toString());
    return Moods(
      id: id,
      title: json['name'] as String,
      thumbnail: json['thumbnail'] as String,
      mediaCount: count,
    );
  }
}
