import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerInformation {
  const PlayerInformation({
    required this.name,
    required this.address,
    required this.district,
    required this.city,
    required this.dob,
    required this.email,
    required this.avatarImageUrl,
    required this.gender,
    required this.phoneNumber,
    required this.teams,
  });

  PlayerInformation.fromSnapshot(DocumentSnapshot snapshot)
      : name = snapshot['name'],
        address = snapshot['address'],
        district = snapshot['district'],
        city = snapshot['city'],
        dob = snapshot['dob'],
        email = snapshot['email'],
        avatarImageUrl = snapshot['avatarImageUrl'],
        gender = snapshot['gender'],
        phoneNumber = snapshot['phone'],
        teams = (snapshot['joinedTeams'] as List)
            .map((item) => item as String)
            .toList();

  final String name;
  final String address;
  final String district;
  final String city;
  final String dob;
  final String email;
  final String avatarImageUrl;
  final String gender;
  final String phoneNumber;
  final List<String> teams;
}
