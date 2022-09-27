import 'dart:async';

import 'package:blog_app/core/index.dart';
import 'package:blog_app/ui/blogs/screens/blogs_page.dart';
import 'package:blog_app/ui/blogs/screens/create_blog_page.dart';
import 'package:blog_app/ui/home/screens/home_page.dart';
import 'package:blog_app/ui/login/screen/login_page.dart';
import 'package:blog_app/ui/profile/bloc/profile.dart';
import 'package:blog_app/ui/profile/screen/search_profile_page.dart';
import 'package:blog_app/ui/register/screen/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  loggerConfigure();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyDqkmsby6EHHpTDV4FuVfCs-lpLxDaMcrY',
      appId: '1:976571806521:android:b1c4e2f0b907d9fa5beee8',
      messagingSenderId: '976571806521',
      projectId: 'blog-app-cfb98',
      storageBucket: "gs://blog-app-cfb98.appspot.com",
    ),
  );

  runZonedGuarded<Future<void>>(() async {
    // await Firebase.initializeApp();
    String? token = await SharedPreferenceHelper.getToken();
    // FirebaseMessaging.instance.getToken().then((fbToken) {
    //   log.info("fbToken $fbToken");
    // });
    log.info("TOKEN $token");
    runApp(MyApp(
      token: token ?? '',
    ));
  }, (e, s) {
    // HANDLE CRASH
  });
}

class MyApp extends StatelessWidget {
  final String token;
  const MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    log.info('APP STARTED');
    return MaterialApp(
        title: 'Blog App',
        theme: ThemeData(),
        routes: {
          LoginPage.tag: (context) => LoginPage(),
          HomePage.tag: (context) => HomePage(),
          RegisterPage.tag: (context) => RegisterPage(),
          BlogsPage.tag: (context) => BlogsPage(),
          ProfilePage.tag: (context) => ProfilePage(),
          SearchProfilePage.tag: (context) => SearchProfilePage(),
          CreateBlogPage.tag: (context) => CreateBlogPage(),
        },
        home: token.isEmpty ? LoginPage() : HomePage());
  }
}
