import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:sportifind/features/profile/data/models/player_model.dart';
import 'package:sportifind/features/profile/data/models/stadium_owner_model.dart';
import 'package:sportifind/features/profile/domain/entities/player.dart';
import 'package:sportifind/features/profile/domain/entities/stadium_owner.dart';
import 'package:sportifind/features/profile/domain/repositories/profile_repository.dart';
import 'package:sportifind/features/user/domain/entities/user.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource profileRemoteDataSource;

  ProfileRepositoryImpl({
    required this.profileRemoteDataSource,
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
  Future<Result<Player>> getPlayer(String id) async{
    PlayerModel player = await profileRemoteDataSource.getPlayer(id);
    return Result.success(await player.toEntity());
  }

  // GET ALL PLAYERS
  // Get all players
  @override
  Future<Result<List<Player>>> getAllPlayers() async{
    List<PlayerModel> players = await profileRemoteDataSource.getAllPlayers();
    return Result.success(await Future.wait(players.map((player) async => await player.toEntity()).toList()));
  }


  // STADIUM OWNER

  // GET STADIUM OWNER
  // Get a stadium owner by its id
  @override
  Future<Result<StadiumOwner>> getStadiumOwner(String id) async{
    StadiumOwnerModel stadiumOwner = await profileRemoteDataSource.getStadiumOwner(id);
    return Result.success(await stadiumOwner.toEntity());
  }

  // GET ALL STADIUM OWNERS
  // Get all stadium owners
  @override
  Future<Result<List<StadiumOwner>>> getAllStadiumOwners() async{
    List<StadiumOwnerModel> stadiumOwners = await profileRemoteDataSource.getAllStadiumOwners();
    return Result.success(await Future.wait(stadiumOwners.map((stadiumOwner) async => await stadiumOwner.toEntity()).toList()));
  }
}