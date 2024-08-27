import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/features/notification/domain/entities/notification_entity.dart';
import 'package:sportifind/features/notification/presentation/widgets/notification_cards.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key, required this.userNoti});

  final List<NotificationEntity> userNoti;

  @override
  State<StatefulWidget> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationEntity> userNotification = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        centerTitle: true,
        title: Text(
          "Notifications",
          style: SportifindTheme.sportifindAppBarForFeature,
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: SportifindTheme.bluePurple,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(20.0),
          child: SizedBox(
            height: 20,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
          children: [
            NotificationCards(
              userNotification: userNotification,
              userNoti: widget.userNoti,
            ),
          ],
        ),
      ),
    );
  }
}
