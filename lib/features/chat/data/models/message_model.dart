import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/features/chat/domain/entities/message_entity.dart';
import 'package:sportifind/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';

class MessageModel {
  final String sender;
  final String message;
  final DateTime time;

  MessageModel({
    required this.sender, 
    required this.message, 
    required this.time
  });

  // REMOTE DATA SOURCE
  ProfileRemoteDataSource profileRemoteDataSource = ProfileRemoteDataSourceImpl();

  // DATA CONVERSION
  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      sender: data['sender'],
      message: data['message'],
      time: data['time'].toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'sender': sender,
      'message': message,
      'time': time,
    };
  }

  factory MessageModel.fromEntity(MessageEntity messageEntity){
    return MessageModel(
      sender: messageEntity.sender.id,
      message: messageEntity.message,
      time: messageEntity.time,
    );
  }

  Future<MessageEntity> toEntity() async{
    PlayerEntity senderEntity = await profileRemoteDataSource.getPlayer(sender).then((value) => value.toEntity());
    return MessageEntity(
      sender: senderEntity,
      message: message,
      time: time,
    );
  }
}