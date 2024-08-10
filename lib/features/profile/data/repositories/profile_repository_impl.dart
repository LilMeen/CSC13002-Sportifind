import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:sportifind/features/profile/data/models/player_model.dart';
import 'package:sportifind/features/profile/data/models/stadium_owner_model.dart';
import 'package:sportifind/features/profile/domain/entities/player.dart';
import 'package:sportifind/features/profile/domain/entities/stadium_owner.dart';
import 'package:sportifind/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
  });

  // PLAYER

  // GET PLAYER
  // Get a player by its id
  @override
  Future<Result<Player>> getPlayer(String id) async{
    PlayerModel player = await remoteDataSource.getPlayer(id);
    return Result.success(await player.toEntity());
  }


  // STADIUM OWNER

  // GET STADIUM OWNER
  // Get a stadium owner by its id
  @override
  Future<Result<StadiumOwner>> getStadiumOwner(String id) async{
    StadiumOwnerModel stadiumOwner = await remoteDataSource.getStadiumOwner(id);
    return Result.success(await stadiumOwner.toEntity());
  }
}