import 'dart:async';

import 'package:blog_app/core/index.dart';
import 'package:blog_app/core/util/singletone.dart';
import 'package:blog_app/ui/profile/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'profile.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial());

  ProfileState get initialState => ProfileInitial();

  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ProfileUpdateButtonPressed) {
      yield ProfileLoading();

      try {
        FirebaseFirestore.instance.collection('users').doc(event.uid).update({
          "username": event.username,
          "email": event.email,
        });

        yield ProfileUpdateSuccess();
      } catch (error) {
        log.severe(error.toString(), error);
        yield ProfileUpdateFailure(error: Strings.message.kSomethingWentWrong);
        yield ProfileInitial();
      }
    } else if (event is GetProfile) {
      yield ProfileLoading();

      try {
        UserModel userModel = await FirebaseFirestore.instance
            .collection('users')
            .doc(event.uid)
            .get()
            .then((value) => UserModel().fromJson(value.data()!));

        Singleton.instance.setUser(userModel);

        yield GetProfileSuccess(user: userModel);
      } catch (error) {
        log.severe(error.toString(), error);
        yield GetProfileFailure(error: Strings.message.kSomethingWentWrong);
        yield ProfileInitial();
      }
    } else if (event is Logout) {
      yield LogOutLoading();
      try {
        await SharedPreferenceHelper.clear();

        yield LogOutSuccess();
      } catch (error) {
        log.severe(error.toString(), error);
        yield LogOutFailure(error: Strings.message.kSomethingWentWrong);
        yield ProfileInitial();
      }
    }
  }
}
