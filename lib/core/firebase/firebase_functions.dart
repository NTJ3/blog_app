import 'dart:io';

import 'package:blog_app/core/util/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseFunctions {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> uploadImage(File file, BuildContext context) async {
    try {
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();

      var refrence = _storage.ref().child("/images").child("/$imageName.jpg");

      var uploadTask = await refrence.putFile(file);

      String url = await uploadTask.ref.getDownloadURL();

      showToast('Image Uploaded Successfully', context);

      return url;
    } catch (e) {
      showToast('Upload Image Failed', context);
      return "";
    }
  }

  Future<void> editBlog(
      String id, Map<String, dynamic> map, BuildContext context) async {
    try {
      await _firebaseFirestore.collection('blogs').doc(id).update(map);
    } catch (e) {
      showToast("${e.toString()}", context, isError: true);
    }
  }

  Future<void> deleteMyBlog(String id, BuildContext context) async {
    try {
      await _firebaseFirestore.collection('blogs').doc(id).delete();
    } catch (e) {
      showToast("${e.toString()}", context, isError: true);
    }
  }
}
