import 'package:flutter/material.dart';
import 'package:sportifind/models/notification_data.dart';
import 'package:sportifind/screens/player/notify/widgets/notification_list/notification_cards.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationData> userNotification = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: Container(
        color: Colors.blueGrey,
        width: double.infinity,
        child: Column(
          children: [
            NotificationCards(
              userNotification: userNotification,
            ),
          ],
        ),
      ),
    );
  }
}
