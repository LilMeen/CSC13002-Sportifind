import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/notification/domain/repositories/notification_repository.dart';

class TeamRequestDenyUser implements UseCase<void, TeamRequestDenyUserParams> {
  final NotificationRepository repository;

  TeamRequestDenyUser(this.repository);

  @override
  Future<Result<void>> call(TeamRequestDenyUserParams params) async {
    return await repository.requestDeniedFromUser(
        params.sender, params.receiver);
  }
}

class TeamRequestDenyUserParams {
  final String sender;
  final String receiver;

  TeamRequestDenyUserParams({
    required this.sender,
    required this.receiver,
  });
}
