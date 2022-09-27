import 'dart:async';

import 'package:blog_app/core/index.dart';
import 'package:blog_app/core/util/singletone.dart';
import 'package:blog_app/ui/profile/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:blog_app/ui/login/model/login_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  // final AuthenticationBloc? authenticationBloc;
  // final ApiClient? client;

  LoginBloc() : super(LoginInitial());

  LoginState get initialState => LoginInitial();

  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: event.username, password: event.password);

        if (userCredential != null) {
          String? uID = (userCredential.user?.uid)!;

          await SharedPreferenceHelper.setToken(uID);

          UserModel userModel = await FirebaseFirestore.instance
              .collection('users')
              .doc(uID)
              .get()
              .then((value) => UserModel().fromJson(value.data()!));

          Singleton.instance.setUser(userModel);

          yield LoginSuccess();
        }
      } on FirebaseAuthException catch (e) {
        log.severe(e.message, e);
        if (e.code == 'user-not-found') {
          yield LoginFailure(error: Strings.message.kEmailNotRegistered);
          yield LoginInitial();
        } else {
          yield LoginFailure(error: e.message!);
          yield LoginInitial();
        }
      } catch (error) {
        log.severe(error.toString(), error);
        yield LoginFailure(error: Strings.message.kSomethingWentWrong);
        yield LoginInitial();
      }
    }
  }
}
