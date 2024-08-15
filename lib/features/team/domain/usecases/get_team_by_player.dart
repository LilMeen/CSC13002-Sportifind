import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/domain/repositories/team_repository.dart';

class GetTeamByPlayer implements UseCase<List<TeamEntity>, GetTeamByPlayerParams> {
  final TeamRepository teamRepository;

  GetTeamByPlayer(this.teamRepository);

  @override
  Future<Result<List<TeamEntity>>> call(GetTeamByPlayerParams params) async {
    return await teamRepository.getTeamByPlayer(params.playerId);
  }
}

class GetTeamByPlayerParams {
  final String playerId;

  GetTeamByPlayerParams({required this.playerId});
}