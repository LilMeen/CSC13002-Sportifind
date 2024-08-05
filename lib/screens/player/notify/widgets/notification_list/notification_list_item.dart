import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/models/notification_data.dart';
import 'package:sportifind/screens/player/notify/screeens/notification_screen.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/screens/player/team/screens/team_details.dart';
import 'package:sportifind/util/match_service.dart';
import 'package:sportifind/util/notification_service.dart';
import 'package:sportifind/util/object_handling.dart';
import 'package:sportifind/util/team_service.dart';
import 'package:intl/intl.dart';

class NotificationListItem extends StatefulWidget {
  const NotificationListItem({
    super.key,
    required this.notificationData,
  });

  final NotificationData notificationData;

  @override
  State<StatefulWidget> createState() => _NotificationListItemState();
}

class _NotificationListItemState extends State<NotificationListItem> {
  final user = FirebaseAuth.instance.currentUser!;
  TeamService teamService = TeamService();
  MatchService matchService = MatchService();
  MatchHandling matchHandling = MatchHandling();
  NotificationService notificationService = NotificationService();
  late Future<void> futurebuild;
  String matchId = '';
  String sender = '';
  String receiver = '';
  bool actionTaken = false;

  @override
  void initState() {
    super.initState();
    futurebuild = _initializer(
        widget.notificationData.sender, widget.notificationData.receiver);
  }

  Future<void> _initializer(String senderTeamId, String receiverTeamId) async {
    sender = await convertTeamIdToName(senderTeamId);
    receiver = await convertTeamIdToName(receiverTeamId);
    actionTaken = widget.notificationData.isRead;

    TeamInformation? currentUserTeam =
        await teamService.getTeamInformation(widget.notificationData.receiver);

    for (var i = 0; i < currentUserTeam!.matchInviteRequest!.length; ++i) {
      if (currentUserTeam.matchInviteRequest![i].receiverId ==
              widget.notificationData.receiver &&
          currentUserTeam.matchInviteRequest![i].senderId ==
              widget.notificationData.sender) {
        matchId = currentUserTeam.matchInviteRequest![i].matchId;
      }
    }

    setState(() {}); // Update the state after initialization
  }

  Future<String> convertTeamIdToName(String teamId) async {
    final teamMap = await teamService.generateTeamMap();
    final teamName = teamMap[teamId] ?? 'Unknown Team';
    return teamName;
  }

  String timeAgo(String dateString, String timeString) {
    final combinedString = "$dateString $timeString";
    final format = DateFormat("dd-MM-yyyy HH:mm:ss");
    final dateTime = format.parse(combinedString);
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

  Widget buildInviteMessage(String senderName) {
    double textSize = 18;
    return RichText(
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: "$senderName ",
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

  Widget buildInviteAcceptMessage(String receiverName, String senderName) {
    double textSize = 18;
    return RichText(
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: "$senderName ",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: textSize),
        children: [
          const TextSpan(
            text: "has accepted ",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          TextSpan(
            text: "$receiverName's ",
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const TextSpan(
            text: "invitation",
            style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget buildInviteSentMessage(String receiverName, String senderName) {
    double textSize = 18;
    return RichText(
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: "$senderName ",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: textSize),
        children: [
          const TextSpan(
            text: "invitation has been sent to ",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          TextSpan(
            text: receiverName,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
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
      padding: const EdgeInsets.all(10),
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
              onPressed: () async {
                matchHandling.matchRequestAccepted(
                  widget.notificationData.receiver,
                  widget.notificationData.sender,
                  matchId,
                );
                await notificationService
                    .updateNotificationAsRead(widget.notificationData);
                setState(() {
                  actionTaken = true;
                  widget.notificationData.isRead = true;
                });
              },
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
              onPressed: () async {
                // matchHandling.matchRequestDenied(
                //   widget.notificationData.receiver,
                //   widget.notificationData.sender,
                //   matchId,
                // );
                await notificationService
                    .updateNotificationAsRead(widget.notificationData);
                setState(() {
                  actionTaken = true;
                  widget.notificationData.isRead = true;
                });
              },
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

  Widget buildNotificationContent() {
    switch (widget.notificationData.status) {
      case "match invite":
        return buildInviteMessage(sender);
      case "match accepted":
        return buildInviteAcceptMessage(receiver, sender);
      case "match sent":
        return buildInviteSentMessage(receiver, sender);
      // Add more cases here for different notification types
      default:
        return const Text("Unknown notification status");
    }
  }

  Widget buildNotificationButton() {
    switch (widget.notificationData.type) {
      case "request":
        if (widget.notificationData.status == "match sent") {
          return const Text("");
        } else {
          return buildAcceptAndDeniedButton();
        }

      case "accept":
        return const Text("");
      // Add more cases here for different notification types
      default:
        return const Text("Unknown notification type");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.notificationData.status == "match invite") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    TeamDetails(teamId: widget.notificationData.sender)),
          );
        }
      },
      child: FutureBuilder<void>(
        future: futurebuild,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          } else {
            print(widget.notificationData.status);
            print(widget.notificationData.type);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  prefixIcon(),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildNotificationContent(),
                          timeAndDate(widget.notificationData),
                          const SizedBox(height: 10),
                          if (!actionTaken)
                            buildNotificationButton()
                          else
                            const Text("Invitation accepted"),
                        ],
                      ),
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
