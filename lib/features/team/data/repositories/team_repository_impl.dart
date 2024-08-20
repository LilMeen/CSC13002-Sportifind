import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/features/match/data/datasources/match_remote_data_source.dart';
import 'package:sportifind/features/match/data/models/match_model.dart';
import 'package:sportifind/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:sportifind/features/profile/data/models/player_model.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/team/data/datasources/team_remote_data_source.dart';
import 'package:sportifind/features/team/data/models/team_model.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/domain/repositories/team_repository.dart';

class TeamRepositoryImpl implements TeamRepository {
  final TeamRemoteDataSource teamRemoteDataSource;

  final ProfileRemoteDataSource profileRemoteDataSource;
  final MatchRemoteDataSource matchRemoteDataSource;

  TeamRepositoryImpl({
    required this.teamRemoteDataSource,
    required this.profileRemoteDataSource,
    required this.matchRemoteDataSource,
  });

  // CREATE TEAM
  // Create a new team
  @override
  Future<Result<void>> createTeam (TeamEntity team) async {
    await teamRemoteDataSource.createTeam(TeamModel.fromEntity(team));
    return Result.success(null);
  }

  // GET ALL TEAMS
  // Get all teams
  @override
  Future<Result<List<TeamEntity>>> getAllTeams() async {
    List<TeamModel> teamModelList = await teamRemoteDataSource.getAllTeams();
    List<TeamEntity> teamEntityList = [];
    for (var team in teamModelList) {
      teamEntityList.add(await team.toEntity());
    }
    return Result.success(teamEntityList);
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
    TeamModel team = await teamRemoteDataSource.getTeam(teamId);
    for (var player in team.players){
      PlayerModel playerModel = await profileRemoteDataSource.getPlayer(player);
      playerModel.teams.remove(teamId);
      await profileRemoteDataSource.updatePlayer(playerModel);
    }
    List<MatchModel> matchesrelated = await matchRemoteDataSource.getMatchesByTeam(teamId);
    for (var match in matchesrelated){
      await matchRemoteDataSource.deleteMatch(match.id);
    }
    await teamRemoteDataSource.deleteTeam(teamId);
    return Result.success(null);
  }


  // KICK PLAYER
  // Kick player from team
  @override
  Future<Result<void>> kickPlayer(TeamEntity team, PlayerEntity player, String type) async {
    team.players.remove(player);
    player.teamsId.remove(team.id);
    await teamRemoteDataSource.updateTeam(TeamModel.fromEntity(team));
    await profileRemoteDataSource.updatePlayer(PlayerModel.fromEntity(player));
    return Result.success(null);
  }
}