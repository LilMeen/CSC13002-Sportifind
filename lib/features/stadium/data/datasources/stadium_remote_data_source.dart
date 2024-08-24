import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sportifind/features/match/data/models/match_model.dart';
import 'package:sportifind/features/stadium/data/models/field_model.dart';
import 'package:sportifind/features/stadium/data/models/stadium_model.dart';


abstract interface class StadiumRemoteDataSource {
  Future<void> createStadium(StadiumModel stadium);
  Future<StadiumModel> getStadium(String id);
  Future<List<StadiumModel>> getAllStadiums();
  Future<List<StadiumModel>> getStadiumsByOwner(String ownerId);
  Future<FieldModel> getFieldByNumberId(String stadiumId, int numberId);
  Future<List<MatchModel>> getFieldScedule(String fieldId, String date);
  Future<void> updateStadium(StadiumModel stadium);
  Future<void> updateFields(StadiumModel stadium);
  Future<void> deleteStadium(String id);
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


  /// GET FIELD BY NUMBER ID
  /// Get a field by its number id
  @override
  Future<FieldModel> getFieldByNumberId(String stadiumId, int numberId) async {
    final fieldDocs = await FirebaseFirestore.instance
      .collection('stadiums')
      .doc(stadiumId)
      .collection('fields')
      .where('numberId', isEqualTo: numberId)
      .get();
    final fieldDoc = fieldDocs.docs.first;
    return FieldModel.fromFirestore(fieldDoc);
  }


  /// GET SCHEDULE
  /// Get a field's schedule of the stadium
  @override
  Future<List<MatchModel>> getFieldScedule(String fieldId, String date) async {
    final matchDocs = await FirebaseFirestore.instance
      .collection('matches')
      .where('field', isEqualTo: fieldId)
      .where('date', isEqualTo: date)
      .get();
    List<MatchModel> matches = [];
    for (final matchDoc in matchDocs.docs) {
      matches.add(MatchModel.fromFirestore(matchDoc));
    }
    return matches;
  }


  /// UPDATE STADIUM
  /// Update a stadium
  @override
  Future<void> updateStadium(StadiumModel stadium) async {
    final stadiumRef = FirebaseFirestore.instance.collection('stadiums').doc(stadium.id);
    await stadiumRef.update(stadium.toFirestore());
    await stadiumRef.collection('fields').get().then((fieldDocs) {
      for (final fieldDoc in fieldDocs.docs) {
        fieldDoc.reference.delete();
      }
    });
    for (FieldModel field in stadium.fields) {
      await stadiumRef.collection('fields').add(field.toFirestore());
    }

    final storageRef = FirebaseStorage.instance
      .ref()
      .child('stadiums')
      .child(stadium.id);
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


  /// UPDATE FIELD
  /// Update a field
  @override
  Future<void> updateFields(StadiumModel stadium) async {
    for (FieldModel field in stadium.fields) {
      final fieldRef = FirebaseFirestore.instance.collection('stadiums').doc(stadium.id).collection('fields').doc(field.id);
      await fieldRef.update(field.toFirestore());
    }
  }


  /// DELETE STADIUM
  /// Delete a stadium by its id
  @override
  Future<void> deleteStadium(String id) async {
    final stadiumRef = FirebaseFirestore.instance.collection('stadiums').doc(id);
    final stadiumStorageRef = FirebaseStorage.instance.ref().child('stadiums').child(id);
    
    await _deleteAllFilesInDirectory(stadiumStorageRef);
    await stadiumRef.collection('fields').get().then((fieldDocs) {
      for (final fieldDoc in fieldDocs.docs) {
        fieldDoc.reference.delete();
      }
    });
    await stadiumRef.delete();
    final storageRef = FirebaseStorage.instance.ref().child('stadiums').child(id);
    await storageRef.delete();
  }

  Future<void> _deleteAllFilesInDirectory(Reference ref) async {
    final ListResult result = await ref.listAll();
    for (Reference fileRef in result.items) {
      await fileRef.delete();
    }
    for (Reference subDirRef in result.prefixes) {
      await _deleteAllFilesInDirectory(subDirRef);
    }
  }
}


