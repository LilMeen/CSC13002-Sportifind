import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:sportifind/features/chat/data/models/message_model.dart';
import 'package:sportifind/features/chat/domain/entities/message_entity.dart';
import 'package:sportifind/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource chatRemoteDatasource;

  ChatRepositoryImpl({required this.chatRemoteDatasource});


  @override
  Future<Result<List<MessageEntity>>> getMessagesByTeam(String teamId) async{
    List<MessageEntity> messages = [] ;
    List<MessageModel> messagesModel = await chatRemoteDatasource.getMessagesByTeam(teamId);
    for (var message in messagesModel) {
      messages.add(await message.toEntity());
    }
    return Result.success(messages);
  }

  @override
  Future<Result<void>> sendMessage(String teamId, MessageEntity message) async{
    await chatRemoteDatasource.sendMessage(teamId, MessageModel.fromEntity(message));
    return Result.success(null);
  }
}