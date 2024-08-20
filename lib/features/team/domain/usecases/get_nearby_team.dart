import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/core/util/team_util.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/domain/repositories/team_repository.dart';

class GetNearbyTeam implements UseCase<List<TeamEntity>, GetNearbyTeamParams> {
  final TeamRepository teamRepository;


  GetNearbyTeam(this.teamRepository);

  @override
  Future<Result<List<TeamEntity>>> call(GetNearbyTeamParams params) async {
    List<TeamEntity> nearbyTeams = await teamRepository.getAllTeams().then((value) => value.data!);
    List<TeamEntity> userTeams = await teamRepository.getTeamByPlayer(params.player.id).then((value) => value.data!);
    for (var team in userTeams) {
      nearbyTeams.remove(nearbyTeams.firstWhere((element) => element.id == team.id));
    }
    
    nearbyTeams = sortTeamByLocation(nearbyTeams, params.player.location);
    return Result.success(nearbyTeams);
  }
}

class GetNearbyTeamParams{
  final PlayerEntity player;

  GetNearbyTeamParams({required this.player});
}