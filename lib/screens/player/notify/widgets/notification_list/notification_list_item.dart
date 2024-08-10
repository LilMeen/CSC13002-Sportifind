import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/notification_data.dart';
import 'package:sportifind/screens/player/match/screens/match_info_screen.dart';
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
    required this.onNotificationUpdated,
  });

  final NotificationData notificationData;
  final VoidCallback onNotificationUpdated;

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
  MatchCard? matchInfo;
  String matchId = '';
  String senderId = '';
  String receiverId = '';
  bool actionTaken = false;
  bool? result;

  @override
  void initState() {
    super.initState();
    futurebuild = _initializer(
        widget.notificationData.sender, widget.notificationData.receiver);
  }

  Future<void> _initializer(
      String senderTeamName, String receiverTeamName) async {
    actionTaken = widget.notificationData.isRead;
    senderId = await convertNameToTeamId(senderTeamName);
    receiverId = await convertNameToTeamId(receiverTeamName);
    matchInfo =
        await matchService.getMatchInformation(widget.notificationData.matchId);
    setState(() {}); // Update the state after initialization
  }

  Future<String> convertNameToTeamId(String teamName) async {
    final teamMap = await teamService.generateTeamIdMap();
    final teamId = teamMap[teamName] ?? 'Unknown Team';
    return teamId;
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

  Widget buildAskToJoinMessage(String senderName) {
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
            text: "has asked to join your team's ",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          TextSpan(
            text: "match",
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

  Widget buildInviteDeclineMessage(String receiverName, String senderName) {
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
            text: "has declined ",
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

  Widget buildInviteRejectMessage(String receiverName, String senderName) {
    double textSize = 18;
    return RichText(
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: "$receiverName ",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: textSize),
        children: [
          const TextSpan(
            text: "'s invitation has been rejected by ",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          TextSpan(
            text: senderName,
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
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
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
                  await convertNameToTeamId(widget.notificationData.receiver),
                  await convertNameToTeamId(widget.notificationData.sender),
                  widget.notificationData.matchId,
                  widget.notificationData.status,
                );
                await notificationService
                    .updateNotificationAsRead(widget.notificationData);
                setState(() {
                  actionTaken = true;
                  widget.notificationData.isRead = true;
                });
                widget.onNotificationUpdated();
              },
              child: const Text(
                "Accept",
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
                matchHandling.matchRequestDenied(
                  await convertNameToTeamId(widget.notificationData.receiver),
                  await convertNameToTeamId(widget.notificationData.sender),
                  widget.notificationData.matchId,
                );
                await notificationService
                    .updateNotificationAsRead(widget.notificationData);
                setState(() {
                  actionTaken = true;
                  widget.notificationData.isRead = true;
                });

                widget.onNotificationUpdated();
              },
              child: const Text(
                "Decline",
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
        return buildInviteMessage(widget.notificationData.sender);
      case "match join":
        return buildAskToJoinMessage(widget.notificationData.sender);
      case "match accepted":
        return buildInviteAcceptMessage(
            widget.notificationData.receiver, widget.notificationData.sender);
      case "match sent":
        return buildInviteSentMessage(
            widget.notificationData.receiver, widget.notificationData.sender);
      case "match denied":
        return buildInviteDeclineMessage(
            widget.notificationData.receiver, widget.notificationData.sender);
      case "match rejected":
        return buildInviteRejectMessage(
            widget.notificationData.receiver, widget.notificationData.sender);
      // Add more cases here for different notification types
      default:
        return const Text("Unknown notification status");
    }
  }

  Widget buildNotificationButton() {
    if ((widget.notificationData.status == "match invite" && !actionTaken) ||
        (widget.notificationData.status == "match join" && !actionTaken)) {
      return buildAcceptAndDeniedButton();
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        switch (widget.notificationData.status) {
          case "match invite":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TeamDetails(teamId: widget.notificationData.sender),
              ),
            );
          case "match accepted":
            await notificationService
                .updateNotificationAsRead(widget.notificationData);
            setState(() {
              actionTaken = true;
              widget.notificationData.isRead = true;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MatchInfoScreen(matchInfo: matchInfo!, matchStatus: 2,),
              ),
            );
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: widget.notificationData.isRead == false
                ? const Color.fromARGB(195, 143, 202, 250)
                : Colors.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
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
                      buildNotificationButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
