import 'dart:io';


class VideoModel {
  String? name;
  String? url;
  String? video_url;
  String? userId;
  String? categoryId;
  File? file;
  String? updatedAt;
  String? createdAt;
  num? id;

  VideoModel({
    this.name,
    this.url,
    this.video_url,
    this.userId,
    this.file,
    this.categoryId,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  VideoModel.fromJson(dynamic json) {
    name = json['name'];
    url = json['url'];
    video_url = json['video_url'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['url'] = url;
    map['video_url'] = video_url;
    map['user_id'] = userId;
    map['category_id'] = categoryId;
    map['updated_at'] = updatedAt;
    map['created_at'] = createdAt;
    map['id'] = id;
    map['file'] = file;
    return map;
  }
}
