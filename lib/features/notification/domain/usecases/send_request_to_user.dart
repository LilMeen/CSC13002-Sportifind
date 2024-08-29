import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/notification/domain/repositories/notification_repository.dart';

class SendTeamRequest implements UseCase<void, SendTeamRequestParams> {
  final NotificationRepository repository;

  SendTeamRequest(this.repository);

  @override
  Future<Result<void>> call(SendTeamRequestParams params) async {
    return await repository.sendTeamRequest(params.sender, params.receiver);
  }
}

class SendTeamRequestParams {
  final String sender;
  final String receiver;

  SendTeamRequestParams({
    required this.sender,
    required this.receiver,
  });
}
