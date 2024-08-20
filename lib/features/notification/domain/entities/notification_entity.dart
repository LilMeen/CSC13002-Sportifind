import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationEntity {
  String? id;
  bool isRead;
  final String matchId;
  final String receiver;
  final String sender;
  final String senderType;
  final String status;
  final Timestamp time;
  final String type;

  NotificationEntity({
    required this.isRead,
    required this.receiver,
    required this.sender,
    required this.senderType,
    required this.status,
    required this.time,
    required this.matchId,
    required this.type,
    this.id,
  });
}