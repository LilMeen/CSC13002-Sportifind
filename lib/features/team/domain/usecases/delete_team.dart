import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/team/domain/repositories/team_repository.dart';

class DeleteTeam implements UseCase<void, DeleteTeamParams> {
  final TeamRepository teamRepository;

  DeleteTeam(this.teamRepository);

  @override
  Future<Result<void>> call(DeleteTeamParams params) async {
    return await teamRepository.deleteTeam(params.teamId);
  }
}

class DeleteTeamParams {
  final String teamId;

  DeleteTeamParams({
    required this.teamId,
  });
}