import 'package:built_value/built_value.dart';

class BlogModel {
  @nullable
  late String id;

  @nullable
  late String title;

  @nullable
  late String description;

  @nullable
  late String imageUrl;

  @nullable
  late String category;

  @nullable
  late String createdAt;

  BlogModel fromJson(Map<String, dynamic> json) {
    BlogModel user = new BlogModel();
    user.id = json['id'];
    user.title = json['title'];
    user.description = json['description'];
    user.imageUrl = json['imageUrl'];
    user.category = json['category'];
    user.createdAt = json['createdAt'];

    return user;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "imageUrl": imageUrl,
        "category": category,
        "createdAt": createdAt,
      };
}
