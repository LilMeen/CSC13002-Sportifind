
import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/features/profile/domain/entities/player.dart';
import 'package:sportifind/features/profile/domain/entities/stadium_owner.dart';
import 'package:sportifind/features/user/domain/entities/user.dart';

abstract interface class ProfileRepository {
  Future<Result<UserEntity>> getCurrentProfile();

  // PLAYER
  Future<Result<Player>> getPlayer(String id);
  Future<Result<List<Player>>> getAllPlayers();

  // STADIUM OWNER
  Future<Result<StadiumOwner>> getStadiumOwner(String id);
  Future<Result<List<StadiumOwner>>> getAllStadiumOwners();
}