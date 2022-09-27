import 'package:equatable/equatable.dart';

abstract class BlogsState extends Equatable {
  const BlogsState();

  @override
  List<Object> get props => [];
}

class BlogsInitial extends BlogsState {}

class BlogsLoading extends BlogsState {}

class BlogsSuccess extends BlogsState {}

class BlogsFailure extends BlogsState {
  final String error;

  const BlogsFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'BlogsFailure { error: $error }';
}
