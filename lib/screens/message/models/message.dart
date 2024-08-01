import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String sender;
  final String message;
  final String sentBy;
  final DateTime time;

  Message(
      {required this.sender, required this.message, required this.sentBy, required this.time});

  factory Message.fromDocument(DocumentSnapshot doc) {
    return Message(
      sender: doc['sender'],
      message: doc['message'],
      sentBy: doc['sentBy'],
      time: (doc['time'] as Timestamp).toDate(),
    );
  }
}