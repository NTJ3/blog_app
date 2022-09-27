import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class RegisterButtonPressed extends RegisterEvent {
  final String email;
  final String username;
  final String password;
  final BuildContext context;

  const RegisterButtonPressed({
    required this.context,
    required this.username,
    required this.password,
    required this.email,
  });

  @override
  List<Object> get props => [context, username, password, email];

  @override
  String toString() =>
      'RegisterButtonPressed { username: $username, password: $password , email: $email }';
}
