import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

Future<void> deleteAllFilesInDirectory(Reference directoryRef) async {
  final ListResult listResult = await directoryRef.listAll();

  // Delete all files
  for (Reference fileRef in listResult.items) {
    await fileRef.delete();
  }

  // Recursively delete files in subdirectories
  for (Reference subDirRef in listResult.prefixes) {
    await deleteAllFilesInDirectory(subDirRef);
  }
}

Future<File> downloadAvatarFile(String stadiumId) async {
  final ref = FirebaseStorage.instance
      .ref()
      .child('stadiums')
      .child(stadiumId)
      .child('avatar')
      .child('avatar.jpg');

  try {
    final tempDir = await getTemporaryDirectory();
    final avatar = File('${tempDir.path}/avatar.jpg');

    await ref.writeToFile(avatar);

    return avatar;
  } catch (e) {
    throw Exception('Failed to download avatar file: $e');
  }
}

Future<List<File>> downloadImageFiles(
    String stadiumId, int imageslength) async {
  List<File> files = [];

  for (int i = 0; i < imageslength; i++) {
    final ref = FirebaseStorage.instance
        .ref()
        .child('stadiums')
        .child(stadiumId)
        .child('images')
        .child('image_$i.jpg');

    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/image_$i.jpg');

      await ref.writeToFile(file);

      files.add(file);
    } catch (e) {
      throw Exception('Failed to download image files: $e');
    }
  }

  return files;
}

Future<void> uploadAvatar(File avatar, String stadiumId) async {
  try {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('stadiums')
        .child(stadiumId)
        .child('avatar')
        .child('avatar.jpg');

    await storageRef.putFile(avatar);
    final imageUrl = await storageRef.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('stadiums')
        .doc(stadiumId)
        .update({'avatar': imageUrl});
  } catch (e) {
    throw Exception('Failed to upload avatar: $e');
  }
}

Future<void> uploadImages(List<File> images, String stadiumId) async {
  try {
    List<String> imageUrls = [];
    for (int i = 0; i < images.length; i++) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('stadiums')
          .child(stadiumId)
          .child('images')
          .child('image_$i.jpg');

      await storageRef.putFile(images[i]);
      final imageUrl = await storageRef.getDownloadURL();
      imageUrls.add(imageUrl);
    }
    await FirebaseFirestore.instance
        .collection('stadiums')
        .doc(stadiumId)
        .update({'images': imageUrls});
  } catch (e) {
    throw Exception('Failed to upload images: $e');
  }
}