import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/models/notification_data.dart';
import 'package:sportifind/util/invite_join_message.dart';
import 'package:sportifind/util/user_service.dart';
import 'package:intl/intl.dart';

class NotificationListItem extends StatefulWidget {
  const NotificationListItem({super.key, required this.notificationData});

  final NotificationData notificationData;

  @override
  State<StatefulWidget> createState() => _NotificationListItemState();
}

String timeAgo(String dateString, String timeString) {
  // Combine date and time strings
  final combinedString = "$dateString $timeString";

  // Define the date format according to your input strings
  final format = DateFormat(
      "dd-MM-yyyy HH:mm:ss"); // Change the format according to your date and time string format

  // Parse the combined string into a DateTime object
  final dateTime = format.parse(combinedString);

  // Calculate the time difference
  final duration = DateTime.now().difference(dateTime);

  if (duration.inDays > 1) {
    return "${duration.inDays} days ago";
  } else if (duration.inDays == 1) {
    return "1 day ago";
  } else if (duration.inHours > 1) {
    return "${duration.inHours} hours ago";
  } else if (duration.inHours == 1) {
    return "1 hour ago";
  } else if (duration.inMinutes > 1) {
    return "${duration.inMinutes} minutes ago";
  } else if (duration.inMinutes == 1) {
    return "1 minute ago";
  } else {
    return "Just now";
  }
}

Widget buildMessage(NotificationData notificationData) {
  double textSize = 18;
  return RichText(
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: "${notificationData.sender} ",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: textSize),
        children: const [
          TextSpan(
            text: "has invited your team to join ",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          TextSpan(
            text: "their match",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
}

Widget timeAndDate(NotificationData notificationData) {
  return Container(
    margin: const EdgeInsets.only(top: 5),
    child: Text(
      timeAgo(notificationData.formattedDate, notificationData.formattedTime),
      style: TextStyle(
        fontSize: 10,
        color: Colors.grey.shade300,
        decoration: TextDecoration.none,
      ),
    ),
  );
}

Widget prefixIcon() {
  return Container(
    height: 50,
    width: 50,
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.grey.shade300,
    ),
    child: Icon(
      Icons.notifications,
      size: 25,
      color: Colors.grey.shade700,
    ),
  );
}

Widget buildAcceptAndDeniedButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Expanded(
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue.shade800,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextButton(
            onPressed: () {},
            child: const Text(
              "Join",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade500,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextButton(
            onPressed: () {},
            child: const Text(
              "Delete",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    ],
  );
}

class _NotificationListItemState extends State<NotificationListItem> {
  final user = FirebaseAuth.instance.currentUser!;
  InviteJoinService inviteJoinService = InviteJoinService();
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Move to detail screen");
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            prefixIcon(),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildMessage(widget.notificationData),
                    timeAndDate(widget.notificationData),
                    const SizedBox(height: 10),
                    widget.notificationData.type == "request"
                        ? buildAcceptAndDeniedButton()
                        : Text("hehe"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
