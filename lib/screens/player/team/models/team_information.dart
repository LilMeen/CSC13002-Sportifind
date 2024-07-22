import 'package:cloud_firestore/cloud_firestore.dart';

class TeamInformation {
  TeamInformation({
    required this.teamId,
    required this.name,
    required this.address,
    required this.district,
    required this.city,
    required this.avatarImageUrl,
    required this.members,
    required this.captain,
  });

  TeamInformation.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot)
      : name = snapshot['name'],
        address = snapshot['address'],
        district = snapshot['district'],
        city = snapshot['city'],
        avatarImageUrl = snapshot['avatarImage'],
        members = (snapshot['members'] as List)
            .map((item) => item as String)
            .toList(),
        captain = snapshot['captain'], 
        teamId = snapshot.id;

  String teamId; 
  String name;
  String address;
  String district;
  String city;
  String avatarImageUrl;
  String captain;
  List<String> members;
}
