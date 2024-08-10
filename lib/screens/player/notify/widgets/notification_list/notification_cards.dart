import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/models/notification_data.dart';
import 'package:sportifind/util/notification_service.dart';
import 'package:sportifind/screens/player/notify/widgets/notification_list/notification_list.dart';
import 'package:sportifind/util/team_service.dart';
import 'package:sportifind/util/user_service.dart';

// ignore: must_be_immutable
class NotificationCards extends StatefulWidget {
  NotificationCards({super.key, required this.userNotification});

  List<NotificationData> userNotification;

  @override
  State<StatefulWidget> createState() => _NotificationCardsState();
}

class _NotificationCardsState extends State<NotificationCards> {
  final user = FirebaseAuth.instance.currentUser!;
  NotificationService notification = NotificationService();
  UserService userService = UserService();
  TeamService teamService = TeamService();
  late Future<void> initializationFuture;

  Future<void> _initialize() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final userNoti = await notification.getNotificationData();
    List<String> senderId = [];
    List<String> receiverId = [];
    widget.userNotification = [];

    for (var i = 0; i < userNoti.length; ++i) {
      senderId.add(await convertNameToTeamId(userNoti[i].sender));
      receiverId.add(await convertNameToTeamId(userNoti[i].receiver));
    }

    for (var i = 0; i < userNoti.length; ++i) {
      if (userNoti[i].status == "match sent") {
        continue;
      }
      widget.userNotification.add(userNoti[i]);
    }
    print(widget.userNotification);
  }

  Future<String> convertNameToTeamId(String name) async {
    final teamMap = await teamService.generateTeamIdMap();
    final teamId = teamMap[name] ?? 'Unknown Team';
    return teamId;
  }

  void _handleNotificationUpdated() {
    setState(() {
      initializationFuture = _initialize(); // Reload notifications
    });
  }

  @override
  void initState() {
    super.initState();
    initializationFuture = _initialize();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: initializationFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height - 150,
                  width: double.infinity,
                  child: NotificationList(
                    notification: widget.userNotification,
                    onNotificationUpdated: _handleNotificationUpdated,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
