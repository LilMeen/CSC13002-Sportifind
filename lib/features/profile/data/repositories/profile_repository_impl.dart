import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/features/match/data/datasources/match_remote_data_source.dart';
import 'package:sportifind/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:sportifind/features/profile/data/models/player_model.dart';
import 'package:sportifind/features/profile/data/models/stadium_owner_model.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/profile/domain/entities/stadium_owner_entity.dart';
import 'package:sportifind/features/profile/domain/repositories/profile_repository.dart';
import 'package:sportifind/features/stadium/data/datasources/stadium_remote_data_source.dart';
import 'package:sportifind/features/stadium/data/models/stadium_model.dart';
import 'package:sportifind/features/team/data/datasources/team_remote_data_source.dart';
import 'package:sportifind/features/team/data/models/team_model.dart';
import 'package:sportifind/features/team/data/repositories/team_repository_impl.dart';
import 'package:sportifind/features/user/domain/entities/user_entity.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource profileRemoteDataSource;

  final TeamRemoteDataSource teamRemoteDataSource;
  final StadiumRemoteDataSource stadiumRemoteDataSource;
  final MatchRemoteDataSource matchRemoteDataSource;


  ProfileRepositoryImpl({
    required this.profileRemoteDataSource,
    required this.teamRemoteDataSource,
    required this.stadiumRemoteDataSource,
    required this.matchRemoteDataSource,
  });

  // GET CURRENT USER
  // Get the current user
  @override
  Future<Result<UserEntity>> getCurrentProfile() async{
    final user = await profileRemoteDataSource.getCurrentProfile();
    return Result.success(await user.toEntity());
  }

  // PLAYER

  // GET PLAYER
  // Get a player by its id
  @override
  Future<Result<PlayerEntity>> getPlayer(String id) async{
    PlayerModel player = await profileRemoteDataSource.getPlayer(id);
    return Result.success(await player.toEntity());
  }

  // GET ALL PLAYERS
  // Get all players
  @override
  Future<Result<List<PlayerEntity>>> getAllPlayers() async{
    List<PlayerModel> players = await profileRemoteDataSource.getAllPlayers();
    return Result.success(await Future.wait(players.map((player) async => await player.toEntity()).toList()));
  }

  // UPDATE PLAYER
  // Update a player
  @override
  Future<Result<void>> updatePlayer(PlayerEntity player) async{
    await profileRemoteDataSource.updatePlayer(PlayerModel.fromEntity(player));
    return Result.success(null);
  }

  // DELETE PLAYER
  // Delete a player by its id
  @override
  Future<Result<void>> deletePlayer(String playerId) async{
    TeamRepositoryImpl teamRepository = TeamRepositoryImpl(
      teamRemoteDataSource: teamRemoteDataSource,
      profileRemoteDataSource: profileRemoteDataSource,
      matchRemoteDataSource: matchRemoteDataSource,
    );
    List<TeamModel> teamsRelatedModel = await teamRemoteDataSource.getTeamByPlayer(playerId);
    for (var team in teamsRelatedModel) {
      if (team.captain == playerId) {
        await teamRepository.deleteTeam(team.id);
      } else {
        team.players.removeWhere((player) => player == playerId);
        await teamRemoteDataSource.updateTeam(team);
      }
    }
    await profileRemoteDataSource.deletePlayer(playerId);
    return Result.success(null);
  }


  // STADIUM OWNER

  // GET STADIUM OWNER
  // Get a stadium owner by its id
  @override
  Future<Result<StadiumOwnerEntity>> getStadiumOwner(String id) async{
    StadiumOwnerModel stadiumOwner = await profileRemoteDataSource.getStadiumOwner(id);
    return Result.success(await stadiumOwner.toEntity());
  }

  // GET ALL STADIUM OWNERS
  // Get all stadium owners
  @override
  Future<Result<List<StadiumOwnerEntity>>> getAllStadiumOwners() async{
    List<StadiumOwnerModel> stadiumOwners = await profileRemoteDataSource.getAllStadiumOwners();
    return Result.success(await Future.wait(stadiumOwners.map((stadiumOwner) async => await stadiumOwner.toEntity()).toList()));
  }

  // UPDATE STADIUM OWNER
  // Update a stadium owner
  @override
  Future<Result<void>> updateStadiumOwner(StadiumOwnerEntity stadiumOwner) async{
    await profileRemoteDataSource.updateStadiumOwner(StadiumOwnerModel.fromEntity(stadiumOwner));
    return Result.success(null);
  }

  // DELETE STADIUM OWNER
  // Delete a stadium owner by its id
  @override
  Future<Result<void>> deleteStadiumOwner(String stadiumOwnerId) async{
    List<StadiumModel> stadiumsRelated = await stadiumRemoteDataSource.getStadiumsByOwner(stadiumOwnerId);
    for (var stadium in stadiumsRelated) {
      await stadiumRemoteDataSource.deleteStadium(stadium.id);
    }
    await profileRemoteDataSource.deleteStadiumOwner(stadiumOwnerId);
    return Result.success(null);
  }

}