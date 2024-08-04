import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/models/notification_data.dart';
import 'package:sportifind/util/invite_join_message.dart';
import 'package:sportifind/screens/player/notify/widgets/notification_list/notification_list.dart';


// ignore: must_be_immutable
class NotificationCards extends StatefulWidget {
  NotificationCards({super.key, required this.userNotification});

  List<NotificationData> userNotification;

  @override
  State<StatefulWidget> createState() => _NotificationCardsState();
}

class _NotificationCardsState extends State<NotificationCards> {
  final user = FirebaseAuth.instance.currentUser!;
  InviteJoinService inviteJoinService = InviteJoinService();
  late ImageProvider team1ImageProvider;
  late Future<void> initializationFuture;

  Future<void> _initialize() async {
    await inviteJoinService.getNotificationData(widget.userNotification);
    print(widget.userNotification);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: _initialize(),
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
                  height: height,
                  width: width,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: NotificationList(
                      notification: widget.userNotification,
                    ),
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
