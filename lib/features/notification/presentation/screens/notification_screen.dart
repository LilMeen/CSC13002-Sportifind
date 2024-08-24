import 'package:flutter/material.dart';
import 'package:sportifind/features/notification/domain/entities/notification_entity.dart';
import 'package:sportifind/features/notification/presentation/widgets/notification_cards.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationEntity> userNotification = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: Container(
        color: Colors.white,
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
