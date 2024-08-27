import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/match/domain/repositories/match_repository.dart';

class DeleteMatchAnnouce implements UseCase<void, DeleteMatchAnnouceParams> {
  final MatchRepository repository;
  DeleteMatchAnnouce(this.repository);

  @override
  Future<Result<void>> call(DeleteMatchAnnouceParams params) async {
    return await repository.deleteMatchAnnouce(
        params.senderId, params.matchId);
  }
}

class DeleteMatchAnnouceParams {
  final String senderId;
  final String matchId;

  DeleteMatchAnnouceParams({
    required this.senderId,
    required this.matchId,
  });
}
