class LiveStreams {
  final int id;
  final String title, coverPhoto, description, streamUrl, type;
  final bool isFree;

  LiveStreams(
      {this.id,
      this.title,
      this.coverPhoto,
      this.type,
      this.description,
      this.isFree,
      this.streamUrl});

  factory LiveStreams.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    return LiveStreams(
        id: id,
        title: json['title'] as String,
        coverPhoto: json['cover_photo'] as String,
        type: json['type'] as String,
        description: json['description'] as String,
        isFree: int.parse(json['is_free'].toString()) == 0,
        streamUrl: json['source'] as String);
  }

  factory LiveStreams.fromMap(Map<String, dynamic> data) {
    return LiveStreams(
        id: data['id'],
        title: data['title'],
        coverPhoto: data['coverPhoto'],
        description: data['description'],
        isFree: data['isFree'],
        streamUrl: data['streamUrl'],
        type: data['type']);
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "coverPhoto": coverPhoto,
        "type": type,
        "isFree": isFree,
        "streamUrl": streamUrl,
        "description": description
      };
}
