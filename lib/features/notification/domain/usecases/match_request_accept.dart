import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/notification/domain/repositories/notification_repository.dart';

class MatchRequestAccept implements UseCase<void, MatchRequestAcceptParams> {
  final NotificationRepository repository;

  MatchRequestAccept(this.repository);

  @override
  Future<Result<void>> call(MatchRequestAcceptParams params) async {
    return await repository.matchRequestAccepted(params.sender, params.receiver, params.matchId, params.status);
  }
}

class MatchRequestAcceptParams {
  final String sender;
  final String receiver;
  final String matchId;
  final String status;

  MatchRequestAcceptParams({required this.sender, required this.receiver, required this.matchId, required this.status});
}