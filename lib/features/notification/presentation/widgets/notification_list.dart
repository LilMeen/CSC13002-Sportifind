import 'package:flutter/material.dart';
import 'package:sportifind/features/notification/domain/entities/notification_entity.dart';
import 'package:sportifind/features/notification/presentation/widgets/notification_list_item.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({
    super.key,
    required this.notification,
    required this.onNotificationUpdated,
  });

  final List<NotificationEntity> notification;
  final VoidCallback onNotificationUpdated;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: notification.length,
      // separatorBuilder: (BuildContext context, int index) {
      //   return const Divider(
      //     height: 0,
      //   );
      // },
      itemBuilder: (ctx, index) => NotificationListItem(
        notificationData: notification[index],
        onNotificationUpdated: onNotificationUpdated,
      ),
    );
  }
}
