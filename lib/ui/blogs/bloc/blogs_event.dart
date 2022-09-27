import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class BlogsEvent extends Equatable {
  const BlogsEvent();
}

class CreateBlogButtonPressed extends BlogsEvent {
  final BuildContext context;
  final String title, des, category;
  final File? imageFile;

  const CreateBlogButtonPressed({
    required this.context,
    required this.title,
    required this.des,
    required this.category,
    this.imageFile,
  });

  @override
  List<Object> get props => [title, des, category];

  @override
  String toString() =>
      'CreateBlogButtonPressed { title: $title, des: $des, category: $category}';
}
