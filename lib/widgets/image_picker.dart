import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker {
  Future<File?> pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery, // Changed to gallery for selecting images
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage == null) {
      return null;
    }

    return File(pickedImage.path);
  }
}
