import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/notification/domain/repositories/notification_repository.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/domain/repositories/team_repository.dart';

class KickPlayer implements UseCase<void, KickPlayerParams> {
  final TeamRepository repository;
  final NotificationRepository notificationRepository;

  KickPlayer(this.repository, this.notificationRepository);

  @override
  Future<Result<void>> call(KickPlayerParams params) async {
    await notificationRepository.removePlayerFromTeam(params.player.id, params.team.id, params.type);
    return await repository.kickPlayer(params.team, params.player);
  }
}

class KickPlayerParams {
  final TeamEntity team;
  final PlayerEntity player;
  final String type;

  KickPlayerParams({
    required this.team,
    required this.player,
    required this.type,
  });
}