import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/util/location_util.dart';
import 'package:sportifind/features/match/data/datasources/match_remote_data_source.dart';
import 'package:sportifind/features/match/data/models/match_model.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';
import 'package:sportifind/features/match/domain/repositories/match_repository.dart';
import 'package:sportifind/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:sportifind/features/profile/data/models/player_model.dart';

class MatchRepositoryImpl implements MatchRepository {
  final MatchRemoteDataSource matchRemoteDataSource;
  final ProfileRemoteDataSource profileRemoteDataSource;

  MatchRepositoryImpl({
    required this.matchRemoteDataSource,
    required this.profileRemoteDataSource,
  });

  // GET MATCH
  // Get match by match id
  @override
  Future<Result<MatchEntity>> getMatch(String id) {
    return matchRemoteDataSource.getMatch(id).then((match) async => Result.success(await match.toEntity()));
  }

  // GET ALL MATCHES
  // Get all matches
  @override
  Future<Result<List<MatchEntity>>> getAllMatches() {
    return matchRemoteDataSource.getAllMatches().then((matches) async {
      List<MatchEntity> matchEntities = [];
      for (var match in matches) {
        matchEntities.add(await match.toEntity());
      }
      return Result.success(matchEntities);
    });
  }

  // GET MATCHES BY STADIUM
  // Get all matches by stadium id
  @override
  Future<Result<List<MatchEntity>>> getMatchesByStadium(String stadiumId) {
    return matchRemoteDataSource.getMatchesByStadium(stadiumId).then((matches) async {
      List<MatchEntity> matchEntities = [];
      for (var match in matches) {
        matchEntities.add(await match.toEntity());
      }
      return Result.success(matchEntities);
    });
  }

  // GET MATCHES BY TEAM
  // Get all matches by team id
  @override
  Future<Result<List<MatchEntity>>> getMatchesByTeam(String teamId) {
    return matchRemoteDataSource.getMatchesByTeam(teamId).then((matches) async {
      List<MatchEntity> matchEntities = [];
      for (var match in matches) {
        matchEntities.add(await match.toEntity());
      }
      return Result.success(matchEntities);
    });
  }

  // GET MATCHES BY PLAYER
  // Get all matches by player id
  @override
  Future<Result<List<MatchEntity>>> getMatchesByPlayer(String playerId) async {
    PlayerModel currentPlayer = await profileRemoteDataSource.getPlayer(playerId);
    List<MatchModel> playerMatchesModel = [];
    for (var team in currentPlayer.teams) {
      List<MatchModel> teamMatches = await matchRemoteDataSource.getMatchesByTeam(team);
      playerMatchesModel.addAll(teamMatches);
    }
    List<MatchEntity> matchEntities = [];
    for (var match in playerMatchesModel) {
      matchEntities.add(await match.toEntity());
    }
    return Result.success(matchEntities);
  }


  // SORT NEARBY MATCHES
  // Sort matches by distance to marked location
  @override
  Result<List<MatchEntity>> sortNearbyMatches(List<MatchEntity> matches, Location markedLocation) {
    sortByDistance<MatchEntity>(
      matches,
      markedLocation,
      (match) => match.stadium.location,
    );
    return Result.success(matches);
  }
}