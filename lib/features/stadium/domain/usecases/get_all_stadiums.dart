import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium.dart';
import 'package:sportifind/features/stadium/domain/repositories/stadium_repository.dart';

class GetAllStadiums implements UseCase<List<Stadium>, NoParams> {
  GetAllStadiums(this.repository);

  final StadiumRepository repository;

  @override
  Future<Result<List<Stadium>>> call(NoParams params) async {
    return await repository.getAllStadiums();
  }
}