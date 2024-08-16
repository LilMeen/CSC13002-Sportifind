import 'dart:io';

import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/profile/domain/usecases/get_player.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/domain/repositories/team_repository.dart';

class CreateTeam implements UseCase<void, CreateTeamParams> {
  final TeamRepository repository;
  CreateTeam(this.repository);

  @override
  Future<Result<void>> call(CreateTeamParams params) async {
    Location teamLocation = Location(district: params.district, city: params.city);

    PlayerEntity captain = await UseCaseProvider.getUseCase<GetPlayer>().call(
      GetPlayerParams(id: params.captain)
    ).then((value) => value.data!);

    TeamEntity newTeam = TeamEntity(
      id: '',
      name: params.name,
      location: teamLocation,
      captain: captain,
      players: [captain],
      avatar: params.avatar ?? File('assets/no_avatar.png'),
      incomingMatch: {},
    );
    repository.createTeam(newTeam);
    return Result.success(null);
  }
}

class CreateTeamParams {
  final String name;
  final String district;
  final String city;
  final String captain;
  final File? avatar; 

  CreateTeamParams({
    required this.name,
    required this.district,
    required this.city,
    required this.captain,
    this.avatar,
  });
}