import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/notification/domain/repositories/notification_repository.dart';

class MatchRequestDeny implements UseCase<void, MatchRequestDenyParams> {
  final NotificationRepository repository;

  MatchRequestDeny(this.repository);

  @override
  Future<Result<void>> call(MatchRequestDenyParams params) async {
    return await repository.matchRequestDenied(params.senderId, params.receiverId, params.matchId);
  }
}

class MatchRequestDenyParams {
  final String senderId;
  final String receiverId;
  final String matchId;

  MatchRequestDenyParams({required this.senderId, required this.receiverId, required this.matchId});
}