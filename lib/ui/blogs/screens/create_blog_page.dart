import 'package:blog_app/ui/blogs/bloc/blogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateBlogPage extends StatelessWidget {
  static String tag = '/create-blog-screen';

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => new BlogsBloc(),
        child: SafeArea(
          child: CreateBlogScreen(),
        ),
      );
}
