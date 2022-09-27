import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;
  final BuildContext context;
  final bool loginWithGoogle;

  const LoginButtonPressed({
    required this.context,
    required this.username,
    required this.password,
    required this.loginWithGoogle,
  });

  @override
  List<Object> get props => [context, username, password, loginWithGoogle];

  @override
  String toString() =>
      'LoginButtonPressed { username: $username, password: $password,  loginWithGoogle: $loginWithGoogle }';
}
