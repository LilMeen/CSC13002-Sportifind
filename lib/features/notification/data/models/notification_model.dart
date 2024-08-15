import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  NotificationModel({
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

  NotificationModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        isRead = snapshot['isRead'],
        receiver = snapshot['receiver'],
        sender = snapshot['sender'],
        matchId = snapshot['match'],
        senderType = snapshot['senderType'],
        status = snapshot['status'],
        time = snapshot['time'],
        type = snapshot['type'];

  DateTime get dateTime => time.toDate();

  String get formattedDate =>
      "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";

  String get formattedTime =>
      "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";

  String? id;
  bool isRead;
  final String matchId;
  final String receiver;
  final String sender;
  final String senderType;
  final String status;
  final Timestamp time;
  final String type;
}
