import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/profile/domain/repositories/profile_repository.dart';

class GetPlayer implements UseCase<PlayerEntity, GetPlayerParams> {
  final ProfileRepository repository;

  GetPlayer(this.repository);

  @override
  Future<Result<PlayerEntity>> call(GetPlayerParams params) async {
    return await repository.getPlayer(params.id);
  }
}

class GetPlayerParams{
  final String id;

  GetPlayerParams({required this.id});
}