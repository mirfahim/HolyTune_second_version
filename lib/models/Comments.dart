class Comments {
  final int id, mediaId, date, replies, edited;
  final String email, name;
  String content;

  Comments(
      {this.id,
      this.mediaId,
      this.email,
      this.name,
      this.content,
      this.date,
      this.replies,
      this.edited});

  factory Comments.fromJson(Map<String, dynamic> json) {
    //print(json);
    int id = int.parse(json['id'].toString());
    int mediaId = int.parse(json['media_id'].toString());
    int date = int.parse(json['date'].toString());
    int replies = int.parse(json['replies'].toString());
    int edited = int.parse(json['edited'].toString());
    return Comments(
        id: id,
        email: json['email'] as String,
        name: json['name'] as String,
        content: json['content'] as String,
        date: date,
        mediaId: mediaId,
        replies: replies,
        edited: edited);
  }

  factory Comments.fromMap(Map<String, dynamic> data) {
    return Comments(
        id: data['id'],
        email: data['email'],
        name: data['name'],
        content: data['thumbnail'],
        date: data['date'],
        mediaId: data['media_id'],
        replies: data['replies'],
        edited: data['edited']);
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "name": name,
        "content": content,
        "date": date,
        "mediaId": mediaId,
        "replies": replies,
        "edited": edited
      };
}
