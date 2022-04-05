class SliderImageModel {
  String id;
  String description;
  String thumbnail;

  SliderImageModel({this.id, this.description, this.thumbnail});

  SliderImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}
