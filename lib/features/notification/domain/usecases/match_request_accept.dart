import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/notification/domain/repositories/notification_repository.dart';

class MatchRequestAccept implements UseCase<void, MatchRequestAcceptParams> {
  final NotificationRepository repository;

  MatchRequestAccept(this.repository);

  @override
  Future<Result<void>> call(MatchRequestAcceptParams params) async {
    return await repository.matchRequestAccepted(params.senderId, params.receiverId, params.matchId);
  }
}

class MatchRequestAcceptParams {
  final String senderId;
  final String receiverId;
  final String matchId;

  MatchRequestAcceptParams({required this.senderId, required this.receiverId, required this.matchId});
}