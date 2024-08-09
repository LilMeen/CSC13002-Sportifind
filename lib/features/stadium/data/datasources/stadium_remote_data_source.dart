import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sportifind/features/stadium/data/models/field_model.dart';
import 'package:sportifind/features/stadium/data/models/stadium_model.dart';


abstract interface class StadiumRemoteDataSource {
  Future<void> createStadium(StadiumModel stadium);
  Future<StadiumModel> getStadium(String id);
  Future<List<StadiumModel>> getAllStadiums();
  Future<List<StadiumModel>> getStadiumsByOwner(String ownerId);
}



class StadiumRemoteDataSourceImpl implements StadiumRemoteDataSource {
  /// CREATE STADIUM
  /// Create a new stadium
  @override
  Future<void> createStadium(StadiumModel stadium) async {
    final stadiumRef = await FirebaseFirestore.instance.collection('stadiums').add(
      stadium.toFirestore(),
    );
    for (FieldModel field in stadium.fields) {
      await stadiumRef.collection('fields').add(field.toFirestore());
    }
    
    final storageRef = FirebaseStorage.instance
      .ref()
      .child('stadiums')
      .child(stadiumRef.id);
    await storageRef
      .child('avatar')
      .child('avatar.jpg')
      .putFile(File(stadium.avatar));
    for (int i = 0; i < stadium.images.length; i++) {
      await storageRef
        .child('images')
        .child('image_$i.jpg')
        .putFile(File(stadium.images[i]));
    }

    final avatarUrl = await storageRef
      .child('avatar')
      .child('avatar.jpg')
      .getDownloadURL();
    final imageUrls = <String>[];
    for(int i = 0; i < stadium.images.length; i++) {
      final imageUrl = await storageRef
        .child('images')
        .child('image_$i.jpg')
        .getDownloadURL();
      imageUrls.add(imageUrl);
    }
    await stadiumRef.update({
      'avatar': avatarUrl,
      'images': imageUrls,
    });
  }


  /// GET STADIUM
  /// Get a stadium by its id
  @override
  Future<StadiumModel> getStadium(String id) async {
    final stadiumDoc = await FirebaseFirestore.instance.collection('stadiums').doc(id).get();
    final fieldDocs = await stadiumDoc.reference.collection('fields').get();
    final stadium = StadiumModel.fromFirestore(stadiumDoc, fieldDocs.docs);
    return stadium;
  }


  /// GET ALL STADIUMS
  /// Get all stadiums
  @override 
  Future<List<StadiumModel>> getAllStadiums() async {
    final stadiumDocs = await FirebaseFirestore.instance.collection('stadiums').get();
    final stadiums = <StadiumModel>[];
    for (final stadiumDoc in stadiumDocs.docs) {
      final fieldDocs = await stadiumDoc.reference.collection('fields').get();
      stadiums.add(StadiumModel.fromFirestore(stadiumDoc, fieldDocs.docs));
    }
    return stadiums;
  }


  /// GET STADIUMS BY OWNER
  /// Get all stadiums by owner
  @override
  Future<List<StadiumModel>> getStadiumsByOwner(String ownerId) async {
    final stadiumDocs = await FirebaseFirestore.instance.collection('stadiums').where('owner', isEqualTo: ownerId).get();
    final stadiums = <StadiumModel>[];
    for (final stadiumDoc in stadiumDocs.docs) {
      final fieldDocs = await stadiumDoc.reference.collection('fields').get();
      stadiums.add(StadiumModel.fromFirestore(stadiumDoc, fieldDocs.docs));
    }
    return stadiums;
  }
}


