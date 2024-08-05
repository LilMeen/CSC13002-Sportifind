import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/features/stadium/data/models/field_model.dart';
import 'package:sportifind/features/stadium/domain/entities/location.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium.dart';

class StadiumModel extends Stadium {
  StadiumModel({
    required super.id,
    required super.name,
    required super.owner,
    required super.avatar,
    required super.images,
    required super.location,
    required super.openTime,
    required super.closeTime,
    required super.phone,
    required super.fields,
  });

  factory StadiumModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    final location = Location(
      city: data['city'],
      district: data['district'],
      address: data['address'],
      latitude: data['latitude'],
      longitude: data['longitude'],
    );

    return StadiumModel(
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

  static Future<StadiumModel> fromSnapshotAsync(
      DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    final stadiumModel = StadiumModel.fromSnapshot(snapshot);

    final fieldsSnapshot = await snapshot.reference.collection('fields').get();
    final fields =
        fieldsSnapshot.docs.map((doc) => FieldModel.fromSnapshot(doc)).toList();

    return StadiumModel(
      id: stadiumModel.id,
      name: stadiumModel.name,
      owner: stadiumModel.owner,
      avatar: stadiumModel.avatar,
      images: stadiumModel.images,
      location: stadiumModel.location,
      openTime: stadiumModel.openTime,
      closeTime: stadiumModel.closeTime,
      phone: stadiumModel.phone,
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
