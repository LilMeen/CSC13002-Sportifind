// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/core/util/team_util.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';
import 'package:sportifind/features/match/domain/usecases/get_match.dart';
import 'package:sportifind/features/match/presentation/screens/match_info_screen.dart';
import 'package:sportifind/features/match/presentation/screens/match_main_screen.dart';
import 'package:sportifind/features/notification/domain/entities/notification_entity.dart';
import 'package:sportifind/features/notification/domain/usecases/mark_as_read.dart';
import 'package:sportifind/features/notification/domain/usecases/match_request_accept.dart';
import 'package:sportifind/features/notification/domain/usecases/match_request_deny.dart';
import 'package:sportifind/features/notification/domain/usecases/team_request_accept.dart';
import 'package:sportifind/features/notification/domain/usecases/team_request_deny_team.dart';
import 'package:sportifind/features/notification/domain/usecases/team_request_deny_user.dart';
import 'package:sportifind/features/notification/presentation/widgets/accept_message.dart';
import 'package:sportifind/features/notification/presentation/widgets/delete_message.dart';
import 'package:sportifind/features/notification/presentation/widgets/deny_message.dart';
import 'package:sportifind/features/notification/presentation/widgets/invite_message.dart';
import 'package:sportifind/features/notification/presentation/widgets/join_message.dart';
import 'package:sportifind/features/notification/presentation/widgets/kick_message.dart';
import 'package:sportifind/features/notification/presentation/widgets/reject_message.dart';
import 'package:sportifind/features/notification/presentation/widgets/sent_message.dart';
import 'package:sportifind/features/team/presentation/screens/team_details.dart';
import 'package:intl/intl.dart';

class NotificationListItem extends StatefulWidget {
  const NotificationListItem({
    super.key,
    required this.notificationData,
    required this.onNotificationUpdated,
  });

  final NotificationEntity notificationData;
  final VoidCallback onNotificationUpdated;

  @override
  State<StatefulWidget> createState() => _NotificationListItemState();
}

class _NotificationListItemState extends State<NotificationListItem> {
  final user = FirebaseAuth.instance.currentUser!;

  late Future<void> futurebuild;
  MatchEntity? matchInfo;
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
    if (widget.notificationData.type == 'match') {
      matchInfo = await UseCaseProvider.getUseCase<GetMatch>()(
        GetMatchParams(matchId: widget.notificationData.matchId),
      ).then((value) => value.data);
    }

    setState(() {}); // Update the state after initialization
  }

  Future<String> convertNameToTeamId(String teamName) async {
    final teamMap = await generateTeamIdMap();
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

  Widget timeAndDate(NotificationEntity notificationData) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Text(
        timeAgo(notificationData.formattedDate, notificationData.formattedTime),
        style: const TextStyle(
          fontSize: 14,
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

  Widget buildAcceptAndDeniedButtonForMatch() {
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
                await UseCaseProvider.getUseCase<MatchRequestAccept>().call(
                    MatchRequestAcceptParams(
                        sender: await convertNameToTeamId(
                            widget.notificationData.receiver),
                        receiver: await convertNameToTeamId(
                            widget.notificationData.sender),
                        matchId: widget.notificationData.matchId,
                        status: widget.notificationData.status));
                await UseCaseProvider.getUseCase<MarkAsRead>()(
                  MarkAsReadParams(notification: widget.notificationData),
                );
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
                await UseCaseProvider.getUseCase<MatchRequestDeny>().call(
                    MatchRequestDenyParams(
                        senderId: await convertNameToTeamId(
                            widget.notificationData.receiver),
                        receiverId: await convertNameToTeamId(
                            widget.notificationData.sender),
                        matchId: widget.notificationData.matchId));
                await UseCaseProvider.getUseCase<MarkAsRead>()(
                  MarkAsReadParams(notification: widget.notificationData),
                );
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

  Widget buildAcceptAndDeniedButtonForTeam(bool isCaptain) {
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
                await UseCaseProvider.getUseCase<TeamRequestAccept>()
                    .call(TeamRequestAcceptParams(
                  sender:
                      await convertNameToTeamId(widget.notificationData.sender),
                  receiver: await convertNameToTeamId(
                      widget.notificationData.receiver),
                ));
                await UseCaseProvider.getUseCase<MarkAsRead>()(
                  MarkAsReadParams(notification: widget.notificationData),
                );
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
                isCaptain == false
                    ? await UseCaseProvider.getUseCase<TeamRequestDenyUser>()
                        .call(TeamRequestDenyUserParams(
                        sender: await convertNameToTeamId(
                            widget.notificationData.receiver),
                        receiver: await convertNameToTeamId(
                            widget.notificationData.sender),
                      ))
                    : await UseCaseProvider.getUseCase<TeamRequestDenyTeam>()
                        .call(TeamRequestDenyTeamParams(
                        sender: await convertNameToTeamId(
                            widget.notificationData.receiver),
                        receiver: await convertNameToTeamId(
                            widget.notificationData.sender),
                      ));
                await UseCaseProvider.getUseCase<MarkAsRead>()(
                  MarkAsReadParams(notification: widget.notificationData),
                );
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
      // Invite notification
      case "match invite":
        return InviteMessage(
          senderName: widget.notificationData.sender,
          receiverName: widget.notificationData.receiver,
          forMatch: true,
        );
      case "invite":
        return InviteMessage(
          senderName: widget.notificationData.sender,
          receiverName: widget.notificationData.receiver,
          forMatch: false,
        );

      // Join notification
      case "match join":
        return JoinMessage(
          senderName: widget.notificationData.sender,
          receiverName: widget.notificationData.receiver,
          forMatch: true,
        );
      case "join":
        return JoinMessage(
          senderName: widget.notificationData.sender,
          receiverName: widget.notificationData.receiver,
          forMatch: false,
        );

      // Accept notification
      case "match accepted":
        return AcceptMessage(
          senderName: widget.notificationData.sender,
          receiverName: widget.notificationData.receiver,
          forMatch: true,
        );
      case "accepted":
        return AcceptMessage(
          senderName: widget.notificationData.sender,
          receiverName: widget.notificationData.receiver,
          forMatch: false,
        );

      // Sent notification
      case "match sent":
        return SentMessage(
          senderName: widget.notificationData.sender,
          receiverName: widget.notificationData.receiver,
        );
      case "sent":
        return SentMessage(
          senderName: widget.notificationData.sender,
          receiverName: widget.notificationData.receiver,
        );

      // Denied notification
      case "match denied":
        return DenyMessage(
          senderName: widget.notificationData.sender,
          receiverName: widget.notificationData.receiver,
          forMatch: true,
        );
      case "denied":
        return DenyMessage(
          senderName: widget.notificationData.sender,
          receiverName: widget.notificationData.receiver,
          forMatch: false,
        );

      // Rejected notification
      case "match rejected":
        return RejectMessage(
          senderName: widget.notificationData.sender,
          receiverName: widget.notificationData.receiver,
          forMatch: true,
        );
      case "reject":
        return RejectMessage(
          senderName: widget.notificationData.sender,
          receiverName: widget.notificationData.receiver,
          forMatch: false,
        );

      // Delete notification
      case "match deleted":
        return DeleteMessage(
          senderName: widget.notificationData.sender,
          receiverName: widget.notificationData.receiver,
          forMatch: true,
        );
      case "delete":
        return DeleteMessage(
          senderName: widget.notificationData.sender,
          receiverName: widget.notificationData.receiver,
          forMatch: false,
        );
      // Add more cases here for different notification types
      case "kicked":
        return KickMessage(
          senderName: widget.notificationData.sender,
          receiverName: widget.notificationData.receiver,
        );
      case "left":
      default:
        return const Text("Unknown notification status");
    }
  }

  Widget buildNotificationButton() {
    if ((widget.notificationData.status == "match invite" && !actionTaken) ||
        (widget.notificationData.status == "match join" && !actionTaken) &&
            isCaptain == true) {
      return buildAcceptAndDeniedButtonForMatch();
    } else if ((widget.notificationData.status == "invite" && !actionTaken) ||
        (widget.notificationData.status == "join" && !actionTaken)) {
      return buildAcceptAndDeniedButtonForTeam(isCaptain);
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
                builder: (context) => TeamDetails(
                    teamId: widget.notificationData.sender),
              ),
            );
          case "match accepted":
            await UseCaseProvider.getUseCase<MarkAsRead>()(
              MarkAsReadParams(notification: widget.notificationData),
            );
            setState(() {
              actionTaken = true;
              widget.notificationData.isRead = true;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MatchInfoScreen(
                  matchInfo: matchInfo!,
                  matchStatus: 2,
                ),
              ),
            );
          case "match sent":
          case "match deleted":
          case "match rejected":
          case "match denied":
          case "sent":
          case "delete":
          case "rejected":
          case "denied":
          case "accepted": 
          case "invite":
            await UseCaseProvider.getUseCase<MarkAsRead>()(
              MarkAsReadParams(notification: widget.notificationData),
            );
            setState(() {
              actionTaken = true;
              widget.notificationData.isRead = true;
            });
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
