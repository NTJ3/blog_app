import 'dart:async';

import 'package:blog_app/core/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:blog_app/ui/Register/model/Register_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'register.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  // final AuthenticationBloc? authenticationBloc;
  // final ApiClient? client;

  RegisterBloc() : super(RegisterInitial());

  RegisterState get initialState => RegisterInitial();

  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterButtonPressed) {
      yield RegisterLoading();

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        if (userCredential != null) {
          // ADD USER TO CLOUD FIRESTORE

          FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user?.uid)
              .set({
            'username': event.username,
            "email": event.email,
            "password": event.password,
            'photoUrl': '',
            'id': userCredential.user?.uid,
            'createdAt': DateTime.now().toString(),
            'isOnline': true,
            'lastLogin': DateTime.now().toString(),
          });

          await SharedPreferenceHelper.setToken((userCredential.user?.uid)!);
          yield RegisterSuccess();
        }
      } on FirebaseAuthException catch (e) {
        log.severe(
            'FirebaseAuthException Registeration' + e.message.toString(), e);
        if (e.code == 'user-not-found') {
          yield RegisterFailure(error: Strings.message.kEmailNotRegistered);
          yield RegisterInitial();
        } else {
          yield RegisterFailure(error: e.message!);
          yield RegisterInitial();
        }
      } catch (error) {
        log.severe(error.toString(), error);
        yield RegisterFailure(error: Strings.message.kSomethingWentWrong);
        yield RegisterInitial();
      }
    }
  }
}
