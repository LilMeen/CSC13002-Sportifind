import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/profile/domain/repositories/profile_repository.dart';

class UpdatePlayer implements UseCase<void, UpdatePlayerParams> {
  final ProfileRepository repository;

  UpdatePlayer(this.repository);

  @override
  Future<Result<void>> call(UpdatePlayerParams params) async {
    return await repository.updatePlayer(params.player);
  }
}

class UpdatePlayerParams {
  final PlayerEntity player;

  UpdatePlayerParams({
    required this.player,
  });
}