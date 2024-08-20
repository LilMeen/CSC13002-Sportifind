import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/notification/domain/repositories/notification_repository.dart';

class RequestToJoinTeam implements UseCase<void, RequestToJoinTeamParams> {
  final NotificationRepository notificationRepository;

  RequestToJoinTeam(this.notificationRepository);

  @override
  Future<Result<void>> call(RequestToJoinTeamParams params) async {
    return await notificationRepository.sendUserRequest(params.userId, params.teamId);
  }
}

class RequestToJoinTeamParams {
  final String userId;
  final String teamId;

  RequestToJoinTeamParams({
    required this.userId,
    required this.teamId,
  });
}