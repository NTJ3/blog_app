import 'package:blog_app/ui/home/screens/home.dart';
import 'package:blog_app/ui/profile/bloc/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  static String tag = '/home-screen';

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => new ProfileBloc(),
        child: SafeArea(
          child: HomeScreen(),
        ),
      );
}
