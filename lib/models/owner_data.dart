import 'package:cloud_firestore/cloud_firestore.dart';
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
  final String address;
  final String city;
  final String district;
  final String phone;

  OwnerData({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.gender,
    required this.dob,
    required this.address,
    required this.city,
    required this.district,
    required this.phone,
  }) : id = uuid.v4();

  OwnerData.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        name = snapshot['name'],
        email = snapshot['email'],
        password = snapshot['password'],
        role = snapshot['role'],
        gender = snapshot['gender'],
        dob = snapshot['dob'],
        address = snapshot['address'],
        city = snapshot['city'],
        district = snapshot['district'],
        phone = snapshot['phone'];
}
