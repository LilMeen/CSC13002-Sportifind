import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/models/field_data.dart';
import 'package:sportifind/models/location_info.dart';

class StadiumData {
  final String id;
  final String name;
  final String owner;
  final String avatar;
  final List<String> images;
  final LocationInfo location;
  final String openTime;
  final String closeTime;
  final String phone;
  final List<FieldData> fields;

  StadiumData({
    required this.id,
    required this.name,
    required this.owner,
    required this.avatar,
    required this.images,
    required this.location,
    required this.openTime,
    required this.closeTime,
    required this.phone,
    required this.fields,
  });

  factory StadiumData.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    final location = LocationInfo(
      city: data['city'],
      district: data['district'],
      address: data['address'],
      latitude: data['latitude'],
      longitude: data['longitude'],
    );

    return StadiumData(
      id: snapshot.id,
      name: data['name'],
      owner: data['owner'],
      avatar: data['avatar'],
      images: List<String>.from(data['images']),
      location: location,
      openTime: data['open_time'],
      closeTime: data['close_time'],
      phone: data['phone_number'],
      fields: [], // fields will be populated asynchronously
    );
  }

  static Future<StadiumData> fromSnapshotAsync(
      DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    final stadiumData = StadiumData.fromSnapshot(snapshot);

    final fieldsSnapshot = await snapshot.reference.collection('fields').get();
    final fields =
        fieldsSnapshot.docs.map((doc) => FieldData.fromSnapshot(doc)).toList();

    return StadiumData(
      id: stadiumData.id,
      name: stadiumData.name,
      owner: stadiumData.owner,
      avatar: stadiumData.avatar,
      images: stadiumData.images,
      location: stadiumData.location,
      openTime: stadiumData.openTime,
      closeTime: stadiumData.closeTime,
      phone: stadiumData.phone,
      fields: fields,
    );
  }

  int getNumberOfTypeField(String type) {
    return fields.where((field) => field.type == type).length;
  }

  double getPriceOfTypeField(String type) {
    for (var field in fields) {
      if (field.type == type) {
        return field.price;
      }
    }
    return 0;
  }
}
