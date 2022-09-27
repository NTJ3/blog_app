import 'package:built_value/built_value.dart';

class UserModel {
  @nullable
  late String id;

  @nullable
  late String username;

  @nullable
  late String email;

  @nullable
  late String photoUrl;

  @nullable
  late String lastLogin;

  @nullable
  late bool isOnline;

  @nullable
  late String createdAt;

  UserModel fromJson(Map<String, dynamic> json) {
    UserModel user = new UserModel();
    user.id = json['id'];
    user.username = json['username'];
    user.email = json['email'];
    user.photoUrl = json['photoUrl'];
    user.lastLogin = json['lastLogin'];
    user.isOnline = json['isOnline'];
    user.createdAt = json['createdAt'];

    return user;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'photoUrl': photoUrl,
        'lastLogin': lastLogin,
        'isOnline': isOnline,
        'createdAt': createdAt,
      };
}
