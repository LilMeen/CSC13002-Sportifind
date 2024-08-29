import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/notification/domain/repositories/notification_repository.dart';

class RequestAccept implements UseCase<void, RequestAcceptParams> {
  final NotificationRepository notificationRepository;

  RequestAccept(this.notificationRepository);

  @override
  Future<Result<void>> call(RequestAcceptParams params) async {
    return await notificationRepository.requestAccepted(params.userId, params.teamId);
  }
}

class RequestAcceptParams {
  final String userId;
  final String teamId;

  RequestAcceptParams({
    required this.userId,
    required this.teamId,
  });
}