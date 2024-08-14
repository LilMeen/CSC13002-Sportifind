import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/features/team/data/datasources/team_remote_data_source.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/domain/repositories/team_repository.dart';

class TeamRepositoryImpl implements TeamRepository {
  final TeamRemoteDataSource teamRemoteDataSource;

  TeamRepositoryImpl({required this.teamRemoteDataSource});

  @override
  Future<Result<TeamEntity>> getTeam(String id) async {
    TeamEntity teamEntity = await teamRemoteDataSource.getTeam(id).then((value) => value.toEntity());
    return Result.success(teamEntity);
  }
}