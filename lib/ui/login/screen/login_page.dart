import 'package:blog_app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login.dart';

class LoginPage extends StatelessWidget {
  static String tag = '/login-screen';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(Strings.screenTitle.kLogin),
        ),
        body: BlocProvider(
          create: (context) => new LoginBloc(),
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              child: LoginForm(),
            ),
          ),
        ),
      );
}
