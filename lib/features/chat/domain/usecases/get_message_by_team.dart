import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/chat/domain/entities/message_entity.dart';
import 'package:sportifind/features/chat/domain/repositories/chat_repository.dart';

class GetMessageByTeam implements UseCase<List<MessageEntity>, GetMessageByTeamParams> {
  final ChatRepository chatRepository;

  GetMessageByTeam(this.chatRepository);

  @override
  Future<Result<List<MessageEntity>>> call(GetMessageByTeamParams params) async {
    return await chatRepository.getMessagesByTeam(params.teamId);
  }
}

class GetMessageByTeamParams {
  final String teamId;

  GetMessageByTeamParams({required this.teamId});
}