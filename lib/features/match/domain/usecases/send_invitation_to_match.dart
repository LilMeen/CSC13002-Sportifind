import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/match/domain/repositories/match_repository.dart';

class SendInvitationToMatch implements UseCase<void, SendInvitationToMatchParams> {
  final MatchRepository matchRepository;

  SendInvitationToMatch(this.matchRepository);

  @override
  Future<Result<void>> call(SendInvitationToMatchParams params) async {
    return matchRepository.sendInvitationToMatch(params.teamSendId, params.teamReceiveId, params.matchId);
  }
}

class SendInvitationToMatchParams {
  final String teamSendId;
  final String teamReceiveId;
  final String matchId;

  SendInvitationToMatchParams({required this.teamSendId, required this.teamReceiveId, required this.matchId});
}