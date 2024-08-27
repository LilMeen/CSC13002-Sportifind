import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/features/chat/domain/entities/message_entity.dart';

abstract interface class ChatRepository {
  Future<Result<List<MessageEntity>>> getMessagesByTeam(String teamId);
  Future<Result<void>> sendMessage(String teamId, MessageEntity message);
}