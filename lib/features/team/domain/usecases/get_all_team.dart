import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/domain/repositories/team_repository.dart';

class GetAllTeam implements UseCase<List<TeamEntity>, NoParams> {
  final TeamRepository teamRepository;

  GetAllTeam(this.teamRepository);

  @override
  Future<Result<List<TeamEntity>>> call(NoParams params) async {
    final teamData = await teamRepository.getAllTeams();
    return Result.success(teamData.data!);
  }
}
