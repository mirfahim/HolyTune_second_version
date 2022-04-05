class Genres {
  final int id;
  final String title;
  final int mediaCount;

  Genres({
    this.id,
    this.title,
    this.mediaCount,
  });

  factory Genres.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    int count = int.parse(json['media_count'].toString());
    return Genres(
      id: id,
      title: json['name'] as String,
      mediaCount: count,
    );
  }
}
