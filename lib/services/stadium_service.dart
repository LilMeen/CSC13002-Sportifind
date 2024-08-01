import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sportifind/models/location_info.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/services/image_service.dart';
import 'package:sportifind/services/location_service.dart';
import 'package:sportifind/services/search_service.dart';

class StadiumService {
  get defaultAvatar => 'lib/assets/avatar/default_stadium_avatar.jpg';

  final LocationService locService = LocationService();
  final SearchService srchService = SearchService();
  final ImageService imgService = ImageService();

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

  Future<void> submitStadium({
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
}
