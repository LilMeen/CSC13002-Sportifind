import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/auth/widgets/green_white_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key});
  @override
  State<UserImagePicker> createState(){
    return _UserImagePickerState();
  }
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if(pickedImage == null){
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context){
    return Column(children: [
      CircleAvatar(
        radius: 40,
        backgroundColor: Colors.grey,
        foregroundImage: _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
      ),
      TextButton.icon(
        onPressed: (){},
        icon: const Icon(Icons.create_rounded),
        label: const Text(
          'Add Image',
          style: TextStyle(
            color:Colors.black,
          ),
        ),
      ),
    ],);
  }
}
