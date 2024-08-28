import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/notification/domain/repositories/notification_repository.dart';

class TeamRequestAccept implements UseCase<void, TeamRequestAcceptParams> {
  final NotificationRepository repository;

  TeamRequestAccept(this.repository);

  @override
  Future<Result<void>> call(TeamRequestAcceptParams params) async {
    return await repository.requestAccepted(params.sender, params.receiver);
  }
}

class TeamRequestAcceptParams {
  final String sender;
  final String receiver;

  TeamRequestAcceptParams({
    required this.sender,
    required this.receiver,
  });
}
