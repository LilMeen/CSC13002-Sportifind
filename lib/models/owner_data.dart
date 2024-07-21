import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/models/location_info.dart';
import 'package:uuid/uuid.dart';
//import 'package:intl/intl.dart';

//final formatter = DateFormat.yMd();

const uuid = Uuid();

class OwnerData {
  final String id;
  final String name;
  final String email;
  final String password;
  final String role;
  final String gender;
  final String dob;
  final LocationInfo location;
  final String phone;

  OwnerData({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.gender,
    required this.dob,
    required this.location,
    required this.phone,
  }) : id = uuid.v4();

  OwnerData.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        name = snapshot['name'],
        email = snapshot['email'],
        password = snapshot['password'],
        role = snapshot['role'],
        gender = snapshot['gender'],
        dob = snapshot['dob'],
        location = LocationInfo(
          district: snapshot['district'],
          city: snapshot['city'],
          latitude: 10.762622,
          longitude: 106.660172,
        ),
        phone = snapshot['phone'];
}
