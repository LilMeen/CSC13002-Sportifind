import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/profile/domain/entities/player.dart';
import 'package:sportifind/features/profile/domain/repositories/profile_repository.dart';

class GetAllPlayer implements UseCase<List<Player>, NoParams> {
  final ProfileRepository repository;

  GetAllPlayer(this.repository);

  @override
  Future<Result<List<Player>>> call(NoParams params) async {
    return await repository.getAllPlayers();
  }
}