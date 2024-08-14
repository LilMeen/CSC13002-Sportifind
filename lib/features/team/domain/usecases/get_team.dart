import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/domain/repositories/team_repository.dart';

class GetTeam implements UseCase<TeamEntity, GetTeamParams> {
  final TeamRepository teamRepository;

  GetTeam(this.teamRepository);

  @override
  Future<Result<TeamEntity>> call(GetTeamParams params) async {
    return await teamRepository.getTeam(params.id);
  }
}

class GetTeamParams {
  final String id;

  GetTeamParams({required this.id});
}