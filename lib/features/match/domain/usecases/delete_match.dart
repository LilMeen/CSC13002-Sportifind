import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/match/domain/repositories/match_repository.dart';

class DeleteMatch implements UseCase<void, DeleteMatchParams> {
  final MatchRepository repository;
  DeleteMatch(this.repository);

  @override
  Future<Result<void>> call(DeleteMatchParams params) async {
    return await repository.deleteMatch(params.id);
  }
}

class DeleteMatchParams {
  final String id;

  DeleteMatchParams({
    required this.id,
  });
}