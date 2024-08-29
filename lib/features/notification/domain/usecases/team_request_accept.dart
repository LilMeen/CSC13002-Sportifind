import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/notification/domain/repositories/notification_repository.dart';

class TeamRequestAccept implements UseCase<void, TeamRequestAcceptParams> {
  final NotificationRepository repository;

  TeamRequestAccept(this.repository);

  @override
  Future<Result<void>> call(TeamRequestAcceptParams params) async {
    return await repository.requestAccepted(params.userId, params.teamId);
  }
}

class TeamRequestAcceptParams {
  final String userId;
  final String teamId;

  TeamRequestAcceptParams({
    required this.userId,
    required this.teamId,
  });
}
