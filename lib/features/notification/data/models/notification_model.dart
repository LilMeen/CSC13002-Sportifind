import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/features/notification/domain/entities/notification_entity.dart';

class NotificationModel {
  String? id;
  bool isRead;
  String matchId;
  final String receiver;
  final String sender;
  final String senderType;
  final String status;
  final Timestamp time;
  final String type;

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

  NotificationModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        isRead = snapshot['isRead'],
        receiver = snapshot['receiver'],
        sender = snapshot['sender'],
        matchId = snapshot['match'] ?? "",
        senderType = snapshot['senderType'],
        status = snapshot['status'],
        time = snapshot['time'],
        type = snapshot['type'];

  DateTime get dateTime => time.toDate();

  String get formattedDate =>
      "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";

  String get formattedTime =>
      "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";


  Map<String, dynamic> toFirestore() {
    return {
      'isRead': isRead,
      'receiver': receiver,
      'sender': sender,
      'senderType': senderType,
      'status': status,
      'time': time,
      'match': matchId,
      'type': type,
    };
  }

  NotificationEntity toEntity () {
    return NotificationEntity(
      id: id,
      isRead: isRead,
      matchId: matchId,
      receiver: receiver,
      sender: sender,
      senderType: senderType,
      status: status,
      time: time,
      type: type,
    );
  }

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      isRead: entity.isRead,
      matchId: entity.matchId,
      receiver: entity.receiver,
      sender: entity.sender,
      senderType: entity.senderType,
      status: entity.status,
      time: entity.time,
      type: entity.type,
    );
  }
}
