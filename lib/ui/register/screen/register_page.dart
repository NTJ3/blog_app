import 'package:blog_app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/register.dart';

class RegisterPage extends StatelessWidget {
  static String tag = '/register-screen';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(Strings.screenTitle.kRegister),
        ),
        body: BlocProvider(
          create: (context) => new RegisterBloc(),
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              child: RegisterForm(),
            ),
          ),
        ),
      );
}
