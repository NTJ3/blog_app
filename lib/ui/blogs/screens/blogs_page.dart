import 'package:blog_app/ui/blogs/screens/blogs_screen.dart';
import 'package:flutter/material.dart';

class BlogsPage extends StatelessWidget {
  static String tag = '/blogs-screen';

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        child: BlogsScreen(),
      );
}
