import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/notification/domain/repositories/notification_repository.dart';

class SendInviteToTeam implements UseCase<void, SendInviteToTeamParams> {
  final NotificationRepository notificationRepository;

  SendInviteToTeam(this.notificationRepository);

  @override
  Future<Result<void>> call(SendInviteToTeamParams params) async {
    return await notificationRepository.sendTeamRequest(params.teamId, params.playerId);
  }
}

class SendInviteToTeamParams {
  final String teamId;
  final String playerId;

  SendInviteToTeamParams({
    required this.teamId,
    required this.playerId,
  });
}