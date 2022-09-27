import 'package:blog_app/ui/profile/model/user.dart';

class Singleton {
  Singleton._();
  static final Singleton _instance = Singleton._();

  factory Singleton() => _instance;

  static Singleton get instance => _instance;

  UserModel _user = new UserModel();

  void setUser(UserModel userModel) {
    _user = userModel;
  }

  UserModel getUser() => _user;
}
