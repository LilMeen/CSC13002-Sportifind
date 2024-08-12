
import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/profile/domain/entities/stadium_owner_entity.dart';
import 'package:sportifind/features/user/domain/entities/user_entity.dart';

abstract interface class ProfileRepository {
  Future<Result<UserEntity>> getCurrentProfile();

  // PLAYER
  Future<Result<PlayerEntity>> getPlayer(String id);
  Future<Result<List<PlayerEntity>>> getAllPlayers();

  // STADIUM OWNER
  Future<Result<StadiumOwnerEntity>> getStadiumOwner(String id);
  Future<Result<List<StadiumOwnerEntity>>> getAllStadiumOwners();
}