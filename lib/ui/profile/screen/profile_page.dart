import 'package:blog_app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/profile.dart';

class ProfilePage extends StatelessWidget {
  static String tag = '/profile-screen';

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => new ProfileBloc(),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            child: ProfileScreen(),
          ),
        ),
      );
}
