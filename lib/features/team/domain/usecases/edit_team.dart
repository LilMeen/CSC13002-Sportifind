import 'dart:io';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/domain/repositories/team_repository.dart';

class EditTeam implements UseCase<void, EditTeamParams> {
  final TeamRepository repository;
  EditTeam(this.repository);

  @override
  Future<Result<void>> call(EditTeamParams params) async {
    params.team.name = params.name;
    params.team.location = params.location;
    params.team.avatar = params.avatar;
    params.team.images = params.images;
    await repository.updateTeam(params.team);
    return Result.success(null);
  }
}

class EditTeamParams {
  final String name;
  final Location location;
  final File avatar; 
  final List<File> images;
  final TeamEntity team;

  EditTeamParams({
    required this.name,
    required this.location,
    required this.avatar,
    required this.images,
    required this.team,
  });
}