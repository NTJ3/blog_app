import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class ProfileUpdateButtonPressed extends ProfileEvent {
  final String email, username, uid;

  final BuildContext context;

  const ProfileUpdateButtonPressed({
    required this.context,
    required this.username,
    required this.email,
    required this.uid,
  });

  @override
  List<Object> get props => [context, username, email, uid];

  @override
  String toString() =>
      'ProfileButtonPressed { username: $username, email: $email , uid: $uid }';
}

class GetProfile extends ProfileEvent {
  final String uid;

  const GetProfile({
    required this.uid,
  });

  @override
  List<Object> get props => [
        uid,
      ];

  @override
  String toString() => 'GetProfile { uid: $uid }';
}

class Logout extends ProfileEvent {
  const Logout();

  @override
  List<Object> get props => [];
}
