import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/features/team/data/datasources/team_remote_data_source.dart';
import 'package:sportifind/features/team/data/models/team_model.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/domain/repositories/team_repository.dart';

class TeamRepositoryImpl implements TeamRepository {
  final TeamRemoteDataSource teamRemoteDataSource;

  TeamRepositoryImpl({required this.teamRemoteDataSource});

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
}