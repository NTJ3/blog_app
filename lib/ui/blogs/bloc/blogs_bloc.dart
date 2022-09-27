import 'dart:async';

import 'package:blog_app/core/firebase/firebase_functions.dart';
import 'package:blog_app/core/index.dart';
import 'package:blog_app/core/util/singletone.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'blogs.dart';

class BlogsBloc extends Bloc<BlogsEvent, BlogsState> {
  BlogsBloc() : super(BlogsInitial());

  BlogsState get initialState => BlogsInitial();

  Stream<BlogsState> mapEventToState(BlogsEvent event) async* {
    if (event is CreateBlogButtonPressed) {
      yield BlogsLoading();

      try {
        String userId = Singleton.instance.getUser().id;
        String imageUrl = '';
        if (event.imageFile != null) {
          imageUrl = await FirebaseFunctions()
              .uploadImage(event.imageFile!, event.context);
        }

        final DocumentReference<Map<String, dynamic>> blogRes =
            await FirebaseFirestore.instance.collection('blogs').add({
          "title": event.title,
          "description": event.des,
          "category": event.category,
          "userId": userId,
          "imageUrl": imageUrl,
          'createdAt': DateTime.now().toString(),
        });

        log.info('CREATE BLOG RES ${blogRes.get()}');

        yield BlogsSuccess();
      } catch (error) {
        log.severe(error.toString(), error);
        yield BlogsFailure(error: Strings.message.kSomethingWentWrong);
        yield BlogsInitial();
      }
    }
  }
}
