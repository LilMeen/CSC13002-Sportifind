import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportifind/core/entities/location.dart';

class StadiumOwner {
  final String id;
  final String name;
  final String email;
  final String role;
  final String gender;
  final String dob;
  final Location location;
  final String phone;

  StadiumOwner({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.gender,
    required this.dob,
    required this.location,
    required this.phone,
  });

  StadiumOwner.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
  : id = snapshot.id,
    name = snapshot['name'],
    email = snapshot['email'],
    role = snapshot['role'],
    gender = snapshot['gender'],
    dob = snapshot['dob'],
    location = Location(
      district: snapshot['district'],
      city: snapshot['city'],
      latitude: 10.762622,
      longitude: 106.660172,
    ),
    phone = snapshot['phone'];

}

Future<StadiumOwner> getStadiumOwner () async {
  try {
    User? userFB = FirebaseAuth.instance.currentUser;
    if (userFB != null) {
      String uid = userFB.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (snapshot.exists) {
        return StadiumOwner.fromSnapshot(snapshot);
      }
    }
    throw Exception('User not found');
  } catch (error) {
    throw Exception('Failed to load user data: $error');
  }
}