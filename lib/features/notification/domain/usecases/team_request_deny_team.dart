import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/notification/domain/repositories/notification_repository.dart';

class TeamRequestDenyTeam implements UseCase<void, TeamRequestDenyTeamParams> {
  final NotificationRepository repository;

  TeamRequestDenyTeam(this.repository);

  @override
  Future<Result<void>> call(TeamRequestDenyTeamParams params) async {
    return await repository.requestDeniedFromTeam(
        params.sender, params.receiver);
  }
}

class TeamRequestDenyTeamParams {
  final String sender;
  final String receiver;

  TeamRequestDenyTeamParams({
    required this.sender,
    required this.receiver,
  });
}
