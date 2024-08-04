import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationData {
  NotificationData({
    required this.isRead,
    required this.receiver,
    required this.sender,
    required this.senderType,
    required this.status,
    required this.time,
    required this.type,
    this.id,
  });

  NotificationData.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        isRead = snapshot['isRead'],
        receiver = snapshot['receiver'],
        sender = snapshot['sender'],
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
  final bool isRead;
  final String receiver;
  final String sender;
  final String senderType;
  final String status;
  final Timestamp time;
  final String type;
}
