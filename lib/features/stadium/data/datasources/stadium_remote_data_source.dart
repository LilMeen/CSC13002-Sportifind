import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sportifind/features/stadium/data/models/stadium_model.dart';
import 'package:sportifind/core/entities/location.dart';

abstract interface class StadiumRemoteDataSource {
  Future<void> createStadium({
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
  Future<void> createStadium({
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
    final stadiumRef = await FirebaseFirestore.instance.collection('stadiums').add({
      'name': name,
      'owner': FirebaseAuth.instance.currentUser!.uid,
      'city': location.city,
      'district': location.district,
      'address': location.address,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'phone_number': phoneNumber,
      'open_time': openTime,
      'close_time': closeTime,
    });

    final stadiumId = stadiumRef.id;
    await _uploadAvatar(avatar, stadiumId);
    await _uploadImages(images, stadiumId);

    int numberId = 1;
    Future<void> addFields(int count, String type, double price) async {
      for (int i = 0; i < count; i++) {
        await stadiumRef.collection('fields').add({
          'numberId': numberId++,
          'status': true,
          'type': type,
          'price_per_hour': price,
        });
      }
    }

    await addFields(num5PlayerFields, '5-Player', pricePerHour5);
    await addFields(num7PlayerFields, '7-Player', pricePerHour7);
    await addFields(num11PlayerFields, '11-Player', pricePerHour11);
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
  Future<void> _uploadAvatar(File avatar, String stadiumId) async {
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

  Future<void> _uploadImages(List<File> images, String stadiumId) async {
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