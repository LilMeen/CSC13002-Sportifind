import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';

abstract interface class TeamRepository {
  Future<Result<void>> createTeam(TeamEntity team);
  Future<Result<TeamEntity>> getTeam(String id);
  Future<Result<List<TeamEntity>>> getTeamByPlayer(String playerId);
}