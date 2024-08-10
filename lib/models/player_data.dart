import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/models/location_info.dart';
import 'package:sportifind/models/notification_data.dart';

class PlayerData {
  final String id;
  final String name;
  final String email;
  final String avatarImage;
  final String role;
  final LocationInfo location;
  final String dob;
  final String gender;
  final String phoneNumber;
  final List<String> teams;
  final List<NotificationData> notifications;

  PlayerData({
    required this.id,
    required this.name,
    required this.avatarImage,
    required this.email,
    required this.role,
    required this.location,
    required this.dob,
    required this.gender,
    required this.phoneNumber,
    required this.teams,
    required this.notifications,
  });

  PlayerData.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        name = snapshot['name'],
        avatarImage = snapshot['avatarImage'],
        email = snapshot['email'],
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
            [],
        notifications = [];

  static Future<PlayerData> fromSnapshotAsync(
      DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    final playerData = PlayerData.fromSnapshot(snapshot);

    final notificationsSnapshot =
        await snapshot.reference.collection('notifications').get();
    final notifications = notificationsSnapshot.docs
        .map((doc) => NotificationData.fromSnapshot(doc))
        .toList();

    return PlayerData(
      id: playerData.id,
      name: playerData.name,
      email: playerData.email,
      avatarImage: playerData.avatarImage,
      role: playerData.role,
      location: playerData.location,
      dob: playerData.dob,
      gender: playerData.gender,
      phoneNumber: playerData.phoneNumber,
      teams: playerData.teams,
      notifications: notifications,
    );
  }
}
