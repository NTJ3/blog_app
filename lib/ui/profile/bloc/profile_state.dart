import 'package:blog_app/ui/profile/model/user.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileUpdateSuccess extends ProfileState {}

class ProfileUpdateFailure extends ProfileState {
  final String error;

  const ProfileUpdateFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ProfileUpdateFailure { error: $error }';
}

class GetProfileSuccess extends ProfileState {
  final UserModel user;

  const GetProfileSuccess({required this.user});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'GetProfileSuccess { user: ${user.toJson()} }';
}

class GetProfileFailure extends ProfileState {
  final String error;

  const GetProfileFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'GetProfileFailure { error: $error }';
}

class LogOutLoading extends ProfileState {}

class LogOutSuccess extends ProfileState {
  const LogOutSuccess();

  @override
  List<Object> get props => [];
}

class LogOutFailure extends ProfileState {
  final String error;

  const LogOutFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'LogOutFailure { error: $error }';
}
