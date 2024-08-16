import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';

abstract interface class MatchRepository {
  Future<Result<void>> createMatch(MatchEntity match);
  Future<Result<MatchEntity>> getMatch(String id);
  Future<Result<List<MatchEntity>>> getAllMatches();
  Future<Result<List<MatchEntity>>> getMatchesByStadium(String stadiumId);
  Future<Result<List<MatchEntity>>> getMatchesByTeam(String teamId);
  Future<Result<List<MatchEntity>>> getMatchesByPlayer(String playerId);
  Future<Result<void>> updateMatch(MatchEntity match);
  Future<Result<void>> deleteMatch(String matchId);

  Result<List<MatchEntity>> sortNearbyMatches(List<MatchEntity> matches, Location markedLocation);

  Future<Result<void>> sendRequestToJoinMatch(String teamSendId, String teamReceiveId, String matchId);
  Future<Result<void>> sendInvitationToMatch(String teamSendId, String teamReceiveId, String matchId);
}