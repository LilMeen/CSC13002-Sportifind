import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/profile/domain/entities/player.dart';
import 'package:sportifind/features/profile/domain/repositories/profile_repository.dart';

class GetPlayer implements UseCase<Player, GetPlayerParams> {
  final ProfileRepository repository;

  GetPlayer(this.repository);

  @override
  Future<Result<Player>> call(GetPlayerParams params) async {
    return await repository.getPlayer(params.id);
  }
}

class GetPlayerParams{
  final String id;

  GetPlayerParams({required this.id});
}