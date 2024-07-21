import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/models/location_info.dart';
import 'package:uuid/uuid.dart';
//import 'package:intl/intl.dart';

//final formatter = DateFormat.yMd();

const uuid = Uuid();

class PlayerData {
  final String id;
  final String name;
  final String email;
  //final String avatarImageUrl;
  final String password;
  final String role;
  final LocationInfo location;
  final String dob;
  final String gender;
  final String phoneNumber;
  final List<String> teams;

  PlayerData({
    required this.name,
    //required this.avatarImageUrl,
    required this.email,
    required this.password,
    required this.role,
    required this.location,
    required this.dob,
    required this.gender,
    required this.phoneNumber,
    required this.teams,
  }) : id = uuid.v4();

  PlayerData.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        name = snapshot['name'],
        //avatarImageUrl = snapshot['avatarImageUrl'],
        email = snapshot['email'],
        password = snapshot['password'],
        role = snapshot['role'],
        location = LocationInfo(
          district: snapshot['district'],
          city: snapshot['city'],
          latitude: 10.762622,
          longitude: 106.660172,
        ),
        dob = snapshot['dob'],
        gender = snapshot['gender'],
        phoneNumber = snapshot['phone'],
        teams = (snapshot.data()?['joinedTeams'] as List<dynamic>?)
                ?.map((item) => item as String)
                .toList() ??
            [];

  get avatarImageUrl =>
      'https://console.firebase.google.com/u/0/project/sportifind-d0b25/storage/sportifind-d0b25.appspot.com/files/~2Fusers~2FfybmAxhicRdgBeqas8gkKfxM0v93~2Favatar';
}
