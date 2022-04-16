class SliderImageModel {
  String id;
  String description;
  String url;
  String thumbnail;

  SliderImageModel({this.id, this.description, this.url, this.thumbnail});

  SliderImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    url = json['url'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['url'] = url;
    data['thumbnail'] = thumbnail;
    return data;
  }
}
