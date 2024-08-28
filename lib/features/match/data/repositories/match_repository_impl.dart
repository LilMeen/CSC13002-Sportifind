import 'package:intl/intl.dart';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/util/location_util.dart';
import 'package:sportifind/features/match/data/datasources/match_remote_data_source.dart';
import 'package:sportifind/features/match/data/models/match_model.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';
import 'package:sportifind/features/match/domain/repositories/match_repository.dart';
import 'package:sportifind/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:sportifind/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/team/data/datasources/team_remote_data_source.dart';
import 'package:sportifind/features/team/data/models/team_model.dart';

class MatchRepositoryImpl implements MatchRepository {
  final MatchRemoteDataSource matchRemoteDataSource;
  final ProfileRemoteDataSource profileRemoteDataSource;
  final TeamRemoteDataSource teamRemoteDataSource;
  final NotificationRemoteDataSource notificationRemoteDataSource;

  MatchRepositoryImpl({
    required this.matchRemoteDataSource,
    required this.profileRemoteDataSource,
    required this.teamRemoteDataSource,
    required this.notificationRemoteDataSource,
  });

  // CREATE MATCH
  // Create a new match
  @override
  Future<Result<void>> createMatch(MatchEntity match) async {
    await matchRemoteDataSource.createMatch(MatchModel.fromEntity(match));
    return Result.success(null);
  }

  // GET MATCH
  // Get match by match id
  @override
  Future<Result<MatchEntity>> getMatch(String id) {
    return matchRemoteDataSource
        .getMatch(id)
        .then((match) async => Result.success(await match.toEntity()));
  }

  // GET ALL MATCHES
  // Get all matches
  @override
  Future<Result<List<MatchEntity>>> getAllMatches() {
    return matchRemoteDataSource.getAllMatches().then((matches) async {
      List<MatchEntity> matchEntities = [];
      DateTime now = DateTime.now();
      for (var match in matches) {
        var matchDate = DateFormat("MM/DD/yyyy").parse(match.date);
        if (matchDate.day >= now.day &&
            matchDate.month >= now.month &&
            matchDate.year >= now.year) {
          matchEntities.add(await match.toEntity());
        }
      }
      return Result.success(matchEntities);
    });
  }

  // GET MATCHES BY STADIUM
  // Get all matches by stadium id
  @override
  Future<Result<List<MatchEntity>>> getMatchesByStadium(String stadiumId) {
    return matchRemoteDataSource
        .getMatchesByStadium(stadiumId)
        .then((matches) async {
      List<MatchEntity> matchEntities = [];
      for (var match in matches) {
        matchEntities.add(await match.toEntity());
      }
      return Result.success(matchEntities);
    });
  }

  // GET MATCHES BY FIELD
  // Get all matches by field id
  @override
  Future<Result<List<MatchEntity>>> getMatchesByField(String fieldId) {
    return matchRemoteDataSource.getMatchesByField(fieldId).then((matches) async {
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
    PlayerEntity currentPlayer = await profileRemoteDataSource
        .getPlayer(playerId)
        .then((value) => value.toEntity());
    DateTime now = DateTime.now();
    List<MatchModel> playerMatchesModel = [];
    for (var teamId in currentPlayer.teamsId) {
      List<MatchModel> teamMatches =
          await matchRemoteDataSource.getMatchesByTeam(teamId);
      playerMatchesModel.addAll(teamMatches);
    }
    List<MatchEntity> matchEntities = [];
    for (var match in playerMatchesModel) {
      var matchDate = DateFormat("MM/DD/yyyy").parse(match.date);
      if (matchDate.day >= now.day &&
          matchDate.month >= now.month &&
          matchDate.year >= now.year) {
        matchEntities.add(await match.toEntity());
      }
    }
    return Result.success(matchEntities);
  }

  // UPDATE MATCH
  // Update match by match id
  @override
  Future<Result<void>> updateMatch(MatchEntity match) async {
    await matchRemoteDataSource.updateMatch(MatchModel.fromEntity(match));
    return Result.success(null);
  }

  // DELETE MATCH
  // Delete match by match id
  @override
  Future<Result<void>> deleteMatch(String matchId) async {
    MatchEntity match = await getMatch(matchId).then((value) => value.data!);
    match.team1.incomingMatch.remove(matchId);
    teamRemoteDataSource.updateTeam(TeamModel.fromEntity(match.team1));

    if (match.team2 != null) {
      match.team2!.incomingMatch.remove(matchId);
      teamRemoteDataSource.updateTeam(TeamModel.fromEntity(match.team2!));

    }
    await matchRemoteDataSource.deleteMatch(matchId);
    return Result.success(null);
  }

  // SORT NEARBY MATCHES
  // Sort matches by distance to marked location
  @override
  Result<List<MatchEntity>> sortNearbyMatches(
      List<MatchEntity> matches, Location markedLocation) {
    sortByDistance<MatchEntity>(
      matches,
      markedLocation,
      (match) => match.stadium.location,
    );
    return Result.success(matches);
  }

  // SEND REQUEST TO JOIN MATCH
  // Send request to join a match
  @override
  Future<Result<void>> sendRequestToJoinMatch(
      String teamSendId, String teamReceiveId, String matchId) async {
    matchRemoteDataSource.sendRequestToJoinMatch(
        teamSendId, teamReceiveId, matchId);
    notificationRemoteDataSource.joinMatchRequest(
        teamSendId, teamReceiveId, matchId);
    return Result.success(null);
  }

  // SEND INVITATION TO MATCH
  // Send invitation to a match
  @override
  Future<Result<void>> sendInvitationToMatch(
      String teamSendId, String teamReceiveId, String matchId) async {
    matchRemoteDataSource.sendInvitationToMatch(
        teamSendId, teamReceiveId, matchId);
    notificationRemoteDataSource.inviteMatchRequest(
        teamSendId, teamReceiveId, matchId);
    return Result.success(null);
  }

  // SEND DELETE MATCH ANNOUNCEMENT
  // Send delete match annoucement
  @override
  Future<Result<void>> deleteMatchAnnouce(String senderId, String matchId) async {
    notificationRemoteDataSource.deleteMatch(senderId, matchId);
    return Result.success(null);
  }
}
