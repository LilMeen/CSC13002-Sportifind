import 'package:flutter/material.dart';
import 'package:sportifind/models/notification_data.dart';
import 'package:sportifind/screens/player/notify/widgets/notification_list/notification_list_item.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({super.key, required this.notification});

  final List<NotificationData> notification;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: notification.length,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          height: 0,
        );
      },
      itemBuilder: (ctx, index) => NotificationListItem(
        notificationData: notification[index],
      ),
    );
  }
}
