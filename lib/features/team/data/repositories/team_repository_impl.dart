import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';
import 'package:sportifind/features/match/domain/repositories/match_repository.dart';
import 'package:sportifind/features/profile/domain/repositories/profile_repository.dart';
import 'package:sportifind/features/team/data/datasources/team_remote_data_source.dart';
import 'package:sportifind/features/team/data/models/team_model.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/domain/repositories/team_repository.dart';

class TeamRepositoryImpl implements TeamRepository {
  final TeamRemoteDataSource teamRemoteDataSource;

  final ProfileRepository profileRepository;
  final MatchRepository matchRepository;

  TeamRepositoryImpl({
    required this.teamRemoteDataSource,
    required this.profileRepository,
    required this.matchRepository,
  });

  // CREATE TEAM
  // Create a new team
  @override
  Future<Result<void>> createTeam (TeamEntity team) async {
    await teamRemoteDataSource.createTeam(TeamModel.fromEntity(team));
    return Result.success(null);
  }

  // GET TEAM BY ID
  // Get team by team id
  @override
  Future<Result<TeamEntity>> getTeam(String id) async {
    TeamEntity teamEntity = await teamRemoteDataSource.getTeam(id).then((value) => value.toEntity());
    return Result.success(teamEntity);
  }


  // GET TEAM BY PLAYER ID
  // Get team by player id
  @override
  Future<Result<List<TeamEntity>>> getTeamByPlayer(String playerId) async {
    List<TeamModel> teamModelList = await teamRemoteDataSource.getTeamByPlayer(playerId);
    List<TeamEntity> teamEntityList = [];
    for (var team in teamModelList) {
      teamEntityList.add(await team.toEntity());
    }
    return Result.success(teamEntityList);
  }


  // UPDATE TEAM
  // Update team
  @override
  Future<Result<void>> updateTeam(TeamEntity team) async {
    await teamRemoteDataSource.updateTeam(TeamModel.fromEntity(team));
    return Result.success(null);
  }


  // DELETE TEAM
  // Delete team
  @override
  Future<Result<void>> deleteTeam(String teamId) async {
    TeamEntity team = await getTeam(teamId).then((value) => value.data!);
    for (var player in team.players){
      player.teamsId.remove(teamId);
      await profileRepository.updatePlayer(player);
    }
    List<MatchEntity> matchesrelated = await matchRepository.getMatchesByTeam(teamId).then((value) => value.data!);
    for (var match in matchesrelated){
      matchRepository.deleteMatch(match.id);
    }
    await teamRemoteDataSource.deleteTeam(teamId);
    return Result.success(null);
  }
}