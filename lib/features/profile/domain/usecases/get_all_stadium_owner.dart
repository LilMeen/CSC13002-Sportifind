import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/profile/domain/entities/stadium_owner.dart';
import 'package:sportifind/features/profile/domain/repositories/profile_repository.dart';

class GetAllStadiumOwner implements UseCase<List<StadiumOwner>, NoParams> {
  final ProfileRepository repository;

  GetAllStadiumOwner(this.repository);

  @override
  Future<Result<List<StadiumOwner>>> call(NoParams params) async {
    return await repository.getAllStadiumOwners();
  }
}