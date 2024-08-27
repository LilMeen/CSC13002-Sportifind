import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/chat/domain/entities/message_entity.dart';
import 'package:sportifind/features/chat/domain/repositories/chat_repository.dart';

class SendMessage implements UseCase<void, SendMessageParams> {
  final ChatRepository chatRepository;

  SendMessage(this.chatRepository);

  @override
  Future<Result<void>> call(SendMessageParams params) async {
    return await chatRepository.sendMessage(params.teamId, params.message);
  }
}

class SendMessageParams {
  final String teamId;
  final MessageEntity message;

  SendMessageParams({required this.teamId, required this.message});
}