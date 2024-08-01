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
    required this.incoming,
    required this.captain,
  });

  TeamInformation.empty()
      : teamId = '',
        name = '',
        address = '',
        district = '',
        city = '',
        avatarImageUrl = '',
        incoming = {},
        members = [],
        captain = '';

  TeamInformation.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot)
      : name = snapshot['name'],
        address = snapshot['address'],
        district = snapshot['district'],
        city = snapshot['city'],
        avatarImageUrl = snapshot['avatarImage'],
        incoming = Map<String, bool>.from(snapshot['incoming']),
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
  Map<String, bool> incoming;
  List<String> members;
}
