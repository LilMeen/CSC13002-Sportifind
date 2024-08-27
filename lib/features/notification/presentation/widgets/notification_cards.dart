import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/core/util/team_util.dart';
import 'package:sportifind/features/notification/domain/entities/notification_entity.dart';
import 'package:sportifind/features/notification/presentation/widgets/notification_list.dart';

// ignore: must_be_immutable
class NotificationCards extends StatefulWidget {
  NotificationCards({super.key, required this.userNotification, required this.userNoti});

  List<NotificationEntity> userNotification;
  List<NotificationEntity> userNoti;

  @override
  State<StatefulWidget> createState() => _NotificationCardsState();
}

class _NotificationCardsState extends State<NotificationCards> {
  final user = FirebaseAuth.instance.currentUser!;
  late Future<void> initializationFuture;

  Future<void> _initialize() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    List<String> senderId = [];
    List<String> receiverId = [];
    widget.userNotification = [];

    for (var i = 0; i < widget.userNoti.length; ++i) {
      senderId.add(await convertNameToTeamId(widget.userNoti[i].sender));
      receiverId.add(await convertNameToTeamId(widget.userNoti[i].receiver));
    }

    for (var i = 0; i < widget.userNoti.length; ++i) {
      widget.userNotification.add(widget.userNoti[i]);
    }
  }

  Future<String> convertNameToTeamId(String name) async {
    final teamMap = await generateTeamIdMap();
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
    return Container(
      height: height-200,
      child: FutureBuilder(
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
      ),
    );
  }
}
