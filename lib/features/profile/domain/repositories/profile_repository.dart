
import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/profile/domain/entities/stadium_owner_entity.dart';
import 'package:sportifind/features/user/domain/entities/user_entity.dart';

abstract interface class ProfileRepository {
  Future<Result<UserEntity>> getCurrentProfile();

  // PLAYER
  Future<Result<PlayerEntity>> getPlayer(String id);
  Future<Result<List<PlayerEntity>>> getAllPlayers();
  Future<Result<void>> updatePlayer(PlayerEntity player);
  Future<Result<void>> deletePlayer(String playerId);

  // STADIUM OWNER
  Future<Result<StadiumOwnerEntity>> getStadiumOwner(String id);
  Future<Result<List<StadiumOwnerEntity>>> getAllStadiumOwners();
  Future<Result<void>> updateStadiumOwner(StadiumOwnerEntity stadiumOwner);
  Future<Result<void>> deleteStadiumOwner(String stadiumOwnerId);
}