import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sportifind/models/field_data.dart';
import 'package:sportifind/models/location_info.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/util/image_service.dart';
import 'package:sportifind/util/location_service.dart';
import 'package:sportifind/util/match_service.dart';
import 'package:sportifind/util/search_service.dart';

class StadiumService {
  get defaultAvatar => 'lib/assets/avatar/default_stadium_avatar.jpg';

  final LocationService locService = LocationService();
  final SearchService srchService = SearchService();
  final ImageService imgService = ImageService();

  Future<Map<String, String>> generateStadiumMap() async {
    final stadiumData = await getStadiumsData();
    final stadiumMap = {
      for (var stadium in stadiumData) stadium.id: stadium.name
    };
    return stadiumMap;
  }

  Future<MatchCard> convertStadiumIdToName(MatchCard match) async {
    final stadiumMap = await generateStadiumMap();
    match.stadium = stadiumMap[match.stadium] ?? 'Unknown Stadium';
    return match;
  }

  Future<StadiumData?> getSpecificStadiumsData(String stadiumId) async {
    try {
      // Reference to the specific team document
      DocumentReference<Map<String, dynamic>> stadiumRef =
          FirebaseFirestore.instance.collection('stadiums').doc(stadiumId);

      // Get the document
      DocumentSnapshot<Map<String, dynamic>> stadiumSnapshot =
          await stadiumRef.get();

      // Check if the document exists
      if (stadiumSnapshot.exists) {
        // Use the fromSnapshot constructor to create a TeamInformation object
        StadiumData stadiumInfo = StadiumData.fromSnapshot(stadiumSnapshot);
        return stadiumInfo;
      } else {
        print('No such stadium document exists!');
        return null;
      }
    } catch (e) {
      print('Error getting stadium information: $e');
      return null;
    }
  }

  Future<List<StadiumData>> getStadiumsData() async {
    try {
      final stadiumsQuery =
          await FirebaseFirestore.instance.collection('stadiums').get();
      final stadiumsFutures = stadiumsQuery.docs
          .map((stadium) => StadiumData.fromSnapshotAsync(stadium))
          .toList();
      return await Future.wait(stadiumsFutures);
    } catch (error) {
      throw Exception('Failed to load stadiums data: $error');
    }
  }

  Future<List<StadiumData>> getOwnerStadiumsData() async {
    try {
      final stadiumsQuery = await FirebaseFirestore.instance
          .collection('stadiums')
          .where('owner', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      final stadiumsFutures = stadiumsQuery.docs
          .map((stadium) => StadiumData.fromSnapshotAsync(stadium))
          .toList();
      return await Future.wait(stadiumsFutures);
    } catch (error) {
      throw Exception('Failed to load stadiums data: $error');
    }
  }

  List<StadiumData> sortNearbyStadiums(
      List<StadiumData> stadiums, LocationInfo markedLocation) {
    locService.sortByDistance<StadiumData>(
      stadiums,
      markedLocation,
      (stadium) => stadium.location,
    );
    return stadiums;
  }

  List<StadiumData> performStadiumSearch(List<StadiumData> stadiums,
      String searchText, String selectedCity, String selectedDistrict) {
    return srchService.searchingNameAndLocation(
      listItems: stadiums,
      searchText: searchText,
      selectedCity: selectedCity,
      selectedDistrict: selectedDistrict,
      getNameOfItem: (stadium) => stadium.name,
      getLocationOfItem: (stadium) => stadium.location,
    );
  }

  Future<void> stadiumProcessing({
    required String action,
    required Map<String, TextEditingController> controllers,
    required LocationInfo? location,
    required String selectedCity,
    required String selectedDistrict,
    required int num5PlayerFields,
    required int num7PlayerFields,
    required int num11PlayerFields,
    required File avatar,
    required List<File> images,
    StadiumData? stadium,
  }) async {
    double getPrice(String key) {
      return controllers[key]?.text.isNotEmpty == true
          ? double.parse(controllers[key]!.text)
          : 0.0;
    }

    final double price5 = getPrice('pricePerHour5');
    final double price7 = getPrice('pricePerHour7');
    final double price11 = getPrice('pricePerHour11');

    if (location == null ||
        (location.address != controllers['stadiumAddress']!.text ||
            location.district != selectedDistrict ||
            location.city != selectedCity)) {
      location = await locService.findLatAndLngFull(
          controllers['stadiumAddress']!.text, selectedDistrict, selectedCity);
    }

    if (action == 'create') {
      await createStadium(
        stadiumName: controllers['stadiumName']!.text,
        location: location!,
        phoneNumber: controllers['phoneNumber']!.text,
        openTime: controllers['openTime']!.text,
        closeTime: controllers['closeTime']!.text,
        pricePerHour5: price5,
        pricePerHour7: price7,
        pricePerHour11: price11,
        num5PlayerFields: num5PlayerFields,
        num7PlayerFields: num7PlayerFields,
        num11PlayerFields: num11PlayerFields,
        avatar: avatar,
        images: images,
      );
    }
    if (action == 'edit') {
      await editStadium(
        stadium: stadium!,
        stadiumName: controllers['stadiumName']!.text,
        location: location!,
        phoneNumber: controllers['phoneNumber']!.text,
        openTime: controllers['openTime']!.text,
        closeTime: controllers['closeTime']!.text,
        pricePerHour5: price5,
        pricePerHour7: price7,
        pricePerHour11: price11,
        num5PlayerFields: num5PlayerFields,
        num7PlayerFields: num7PlayerFields,
        num11PlayerFields: num11PlayerFields,
        avatar: avatar,
        images: images,
      );
    }
  }

  Future<void> createStadium({
    required String stadiumName,
    required LocationInfo location,
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
    final stadiumRef =
        await FirebaseFirestore.instance.collection('stadiums').add({
      'name': stadiumName,
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
    await uploadAvatar(avatar, stadiumId);
    await uploadImages(images, stadiumId);

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

  Future<void> editStadium({
    required StadiumData stadium,
    required String stadiumName,
    required LocationInfo location,
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
    final stadiumRef =
        FirebaseFirestore.instance.collection('stadiums').doc(stadium.id);

    await stadiumRef.update({
      'name': stadiumName,
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

    await uploadAvatar(avatar, stadium.id);
    await uploadImages(images, stadium.id);
    for (int i = images.length; i < stadium.images.length; ++i) {
      await FirebaseStorage.instance
          .ref()
          .child('stadiums')
          .child(stadium.id)
          .child('images')
          .child('image_$i.jpg')
          .delete();
    }

    final MatchService matService = MatchService();
    List<MatchCard> matches =
        await matService.getMatchDataByStadiumId(stadium.id);

    final sortedFields = stadium.fields
      ..sort((a, b) => a.numberId.compareTo(b.numberId));

    int numberId = 1;
    int oldfFieldIndex = 0;
    Future<void> editFields(
        int oldCount, int newCount, String type, double price) async {
      for (int i = 0; i < oldCount; i++) {
        await stadiumRef
            .collection('fields')
            .doc(sortedFields[oldfFieldIndex++].id)
            .update({
          'numberId': numberId++,
          'price_per_hour': price,
        });
        if (i >= newCount - 1) {
          break;
        }
      }

      for (int i = oldCount; i < newCount; i++) {
        await stadiumRef.collection('fields').add({
          'numberId': numberId++,
          'status': true,
          'type': type,
          'price_per_hour': price,
        });
      }

      for (int i = newCount; i < oldCount; i++) {
        final fieldMatches = matches
            .where((match) => match.field == sortedFields[oldfFieldIndex].id)
            .toList();
        for (var match in fieldMatches) {
          matService.deleteMatch(match.id);
        }

        await stadiumRef
            .collection('fields')
            .doc(sortedFields[oldfFieldIndex++].id)
            .delete();
      }
    }

    await editFields(stadium.getNumberOfTypeField('5-Player'), num5PlayerFields,
        '5-Player', pricePerHour5);
    await editFields(stadium.getNumberOfTypeField('7-Player'), num7PlayerFields,
        '7-Player', pricePerHour7);
    await editFields(stadium.getNumberOfTypeField('11-Player'),
        num11PlayerFields, '11-Player', pricePerHour11);
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

  Future<void> deleteStadium(String stadiumId) async {
    final MatchService matService = MatchService();

    try {
      final stadiumRef =
          FirebaseStorage.instance.ref().child('stadiums').child(stadiumId);
      await deleteAllFilesInDirectory(stadiumRef);

      final fieldsRef = FirebaseFirestore.instance
          .collection('stadiums')
          .doc(stadiumId)
          .collection('fields');
      final fieldsSnapshot = await fieldsRef.get();
      for (final fieldDoc in fieldsSnapshot.docs) {
        await fieldDoc.reference.delete();
      }

      await FirebaseFirestore.instance
          .collection('stadiums')
          .doc(stadiumId)
          .delete();

      List<MatchCard> matches =
          await matService.getMatchDataByStadiumId(stadiumId);
      for (var match in matches) {
        await matService.deleteMatch(match.id);
      }
    } catch (e) {
      throw Exception('Failed to delete stadium: $e');
    }
  }

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

  Future<void> updateFieldStatus(
      StadiumData stadium, Map<String, String> fieldsStatus) async {
    try {
      for (var field in stadium.fields) {
        await FirebaseFirestore.instance
            .collection('stadiums')
            .doc(stadium.id)
            .collection('fields')
            .doc(field.id)
            .update({
          'status': fieldsStatus[field.id] == 'active',
        });
      }
    } catch (e) {
      throw Exception('Failed to update status: $e');
    }
  }

  Future<List<FieldData>> getFieldData(String stadiumId) async {
    final fieldQuery = await FirebaseFirestore.instance
        .collection('stadiums')
        .doc(stadiumId)
        .collection('fields')
        .get();
    final fields = fieldQuery.docs
        .map((field) => FieldData.fromSnapshot(field))
        .toList();
    return fields;
  }

  Future<Map<int, String>> generateFieldIdMap(String stadiumId) async {
    final fieldData = await getFieldData(stadiumId);
    print(fieldData);
    final fieldMap = {for (var field in fieldData) field.numberId: field.id};
    print(fieldMap);
    return fieldMap;
  }
}
