import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sportifind/features/stadium/data/models/field_model.dart';
import 'package:sportifind/features/stadium/data/models/stadium_model.dart';
import 'package:sportifind/core/entities/location.dart';

abstract interface class StadiumRemoteDataSource {
  Future<void> createStadium(StadiumModel stadium);

  Future<void> updateStadium({
    required String id,
    required String name,
    required Location location,
    required String phoneNumber,
    required String openTime,
    required String closeTime,
    required double pricePerHour5,
    required double pricePerHour7,
    required double pricePerHour11,
    required int num5PlayerFields,
    required int num7PlayerFields,
    required int num11PlayerFields,
    required File avatar,
    required List<File> images,
  });
  Future<void> updateFieldStatus({
    required String stadiumId,
    required String fieldId,
    required bool status,
  });


  Future<List<StadiumModel>> getStadiumList();
  Future<StadiumModel> getStadiumById({required String id});
  Future<List<StadiumModel>> getStadiumsByOwner({required String owner});

  Future<void> deleteStadium({required String id});  
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
  

  /// UPDATE STADIUM
  /// Update an existing stadium
  @override
  Future<void> updateStadium({
    required String id,
    required String name,
    required Location location,
    required String phoneNumber,
    required String openTime,
    required String closeTime,
    required double pricePerHour5,
    required double pricePerHour7,
    required double pricePerHour11,
    required int num5PlayerFields,
    required int num7PlayerFields,
    required int num11PlayerFields,
    required File avatar,
    required List<File> images,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('stadiums').doc(id).update({
        'name': name,
        'location': location,
        'phoneNumber': phoneNumber,
        'openTime': openTime,
        'closeTime': closeTime,
        'pricePerHour5': pricePerHour5,
        'pricePerHour7': pricePerHour7,
        'pricePerHour11': pricePerHour11,
        'num5PlayerFields': num5PlayerFields,
        'num7PlayerFields': num7PlayerFields,
        'num11PlayerFields': num11PlayerFields,
        'avatar': avatar,
        'images': images,
      });
    } catch (error) {
      throw Exception('Failed to update stadium: $error');
    }
  }

  
  /// UPDATE FIELD STATUS
  /// Update the status of a field
  @override
  Future<void> updateFieldStatus({
    required String stadiumId,
    required String fieldId,
    required bool status,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('stadiums')
          .doc(stadiumId)
          .collection('fields')
          .doc(fieldId)
          .update({'status': status});
    } catch (error) {
      throw Exception('Failed to update field status: $error');
    }
  }


  /// GET STADIUM LIST
  /// Get a list of all stadiums
  @override
  Future<List<StadiumModel>> getStadiumList() async {
    try {
      final stadiumsQuery =
          await FirebaseFirestore.instance.collection('stadiums').get();
      final stadiums = stadiumsQuery.docs
          .map((stadium) => StadiumModel.fromFirestore(stadium, []))
          .toList();
      return stadiums;
    } catch (error) {
      throw Exception('Failed to load stadiums data: $error');
    }
  }


  /// GET STADIUM BY ID
  /// Get a stadium by its id
  @override
  Future<StadiumModel> getStadiumById({required String id}) async {
    try {
      final stadiumSnapshot =
        await FirebaseFirestore.instance
          .collection('stadiums')
          .doc(id)
          .get();

      List<DocumentSnapshot> fieldSnapshot = await FirebaseFirestore.instance
          .collection('stadiums')
          .doc(id)
          .collection('fields')
          .get()
          .then((value) => value.docs);
      return  StadiumModel.fromFirestore(stadiumSnapshot, fieldSnapshot);
    } catch (error) {
      throw Exception('Failed to load stadium data: $error');
    }
  }


  /// GET STADIUMS BY OWNER
  /// Get a list of stadiums by their owner
  @override
  Future<List<StadiumModel>> getStadiumsByOwner({required String owner}) async {
    try {
      final stadiumsQuery = await FirebaseFirestore.instance
          .collection('stadiums')
          .where('owner', isEqualTo: owner)
          .get();
      final stadiums = stadiumsQuery.docs
          .map((stadium) => StadiumModel.fromFirestore(stadium, []))
          .toList();
      return stadiums;
    } catch (error) {
      throw Exception('Failed to load stadiums data: $error');
    }
  }


  /// DELETE STADIUM
  /// Delete a stadium by its id
  @override  
  Future<void> deleteStadium({required String id}) async {
    try {
      await FirebaseFirestore.instance.collection('stadiums').doc(id).delete();
    } catch (error) {
      throw Exception('Failed to delete stadium: $error');
    }
  }
}


  ////////////////////////////////
  //////// PRIVATE METHODS
  ///
