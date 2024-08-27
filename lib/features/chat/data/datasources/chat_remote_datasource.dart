import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/features/chat/data/models/message_model.dart';

abstract interface class ChatRemoteDataSource {
  Future<List<MessageModel>> getMessagesByTeam(String teamId);
  Future<void> sendMessage(String teamId, MessageModel message);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  @override
  Future<List<MessageModel>> getMessagesByTeam(String teamId) async {
    final messages = await FirebaseFirestore.instance
        .collection('teams')
        .doc(teamId)
        .collection('messages')
        .orderBy('time')
        .get();
    return messages.docs.map((doc) => MessageModel.fromFirestore(doc)).toList();
  }

  @override
  Future<void> sendMessage(String teamId, MessageModel message) async {
    await FirebaseFirestore.instance
        .collection('teams')
        .doc(teamId)
        .collection('messages')
        .add(message.toFirestore());
  }
}