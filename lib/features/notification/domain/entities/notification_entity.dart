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

  DateTime get dateTime => time.toDate();

  String get formattedDate =>
      "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";

  String get formattedTime =>
      "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
}