import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/features/profile/domain/entities/player.dart';
import 'package:sportifind/features/profile/domain/entities/stadium_owner.dart';

abstract interface class ProfileRepository {
  // PLAYER
  Future<Result<Player>> getPlayer(String id);

  // STADIUM OWNER
  Future<Result<StadiumOwner>> getStadiumOwner(String id);
}