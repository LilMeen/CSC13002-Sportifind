import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/match/domain/repositories/match_repository.dart';

class SendRequestToJoinMatch implements UseCase<void, SendRequestToJoinMatchParams> {
  final MatchRepository matchRepository;

  SendRequestToJoinMatch(this.matchRepository);

  @override
  Future<Result<void>> call(SendRequestToJoinMatchParams params) async {
    return matchRepository.sendRequestToJoinMatch(params.teamSendId, params.teamReceiveId, params.matchId);
  }
}

class SendRequestToJoinMatchParams {
  final String teamSendId;
  final String teamReceiveId;
  final String matchId;

  SendRequestToJoinMatchParams({required this.teamSendId, required this.teamReceiveId, required this.matchId});
}