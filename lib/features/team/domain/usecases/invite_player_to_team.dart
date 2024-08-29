import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/notification/domain/repositories/notification_repository.dart';

class InvitePlayerToTeam implements UseCase<void, InvitePlayerToTeamParams> {
  final NotificationRepository repository;

  InvitePlayerToTeam(this.repository);

  @override
  Future<Result<void>> call(InvitePlayerToTeamParams params) async {
    return await repository.sendTeamRequest(params.userId, params.teamId);
  }
}

class InvitePlayerToTeamParams {
  final String userId;
  final String teamId;

  InvitePlayerToTeamParams({
    required this.userId,
    required this.teamId,
  });
}
