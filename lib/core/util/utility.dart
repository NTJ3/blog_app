import 'dart:io';

import 'package:blog_app/core/index.dart';
import 'package:blog_app/core/util/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Utility {
  static Future<File?> pickImage(BuildContext context) async {
    try {
      ImagePicker _picker = ImagePicker();

      XFile? xFile = await _picker.pickImage(source: ImageSource.gallery);

      if (xFile != null) {
        File imageFile = File((xFile.path));

        return imageFile;
      }
    } catch (e) {
      showToast(Strings.message.kSomethingWentWrong, context, isError: true);
    }
    return null;
  }
}
