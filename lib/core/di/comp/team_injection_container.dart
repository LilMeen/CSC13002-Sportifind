import 'package:get_it/get_it.dart';
import 'package:sportifind/features/team/data/datasources/team_remote_data_source.dart';
import 'package:sportifind/features/team/data/repositories/team_repository_impl.dart';
import 'package:sportifind/features/team/domain/repositories/team_repository.dart';
import 'package:sportifind/features/team/domain/usecases/create_team.dart';
import 'package:sportifind/features/team/domain/usecases/delete_team.dart';
import 'package:sportifind/features/team/domain/usecases/edit_team.dart';
import 'package:sportifind/features/team/domain/usecases/get_all_team.dart';
import 'package:sportifind/features/team/domain/usecases/get_nearby_team.dart';
import 'package:sportifind/features/team/domain/usecases/get_team.dart';
import 'package:sportifind/features/team/domain/usecases/get_team_by_player.dart';
import 'package:sportifind/features/team/domain/usecases/invite_player_to_team.dart';
import 'package:sportifind/features/team/domain/usecases/kick_player.dart';
import 'package:sportifind/features/team/domain/usecases/request_accept.dart';
import 'package:sportifind/features/team/domain/usecases/request_to_join_team.dart';

final GetIt sl = GetIt.instance;

void initializeTeamDependencies() {
  // Data sources
  sl.registerLazySingleton<TeamRemoteDataSource>(
      () => TeamRemoteDataSourceImpl());

  // Repositories
  sl.registerLazySingleton<TeamRepository>(() => TeamRepositoryImpl(
        teamRemoteDataSource: sl(),
        profileRemoteDataSource: sl(),
        matchRemoteDataSource: sl(),
      ));

  // Use cases
  sl.registerLazySingleton<CreateTeam>(() => CreateTeam(sl()));
  sl.registerLazySingleton<DeleteTeam>(() => DeleteTeam(sl()));
  sl.registerLazySingleton<EditTeam>(() => EditTeam(sl()));
  sl.registerLazySingleton<GetAllTeam>(() => GetAllTeam(sl()));
  sl.registerLazySingleton<GetNearbyTeam>(() => GetNearbyTeam(sl()));
  sl.registerLazySingleton<GetTeamByPlayer>(() => GetTeamByPlayer(sl()));
  sl.registerLazySingleton<GetTeam>(() => GetTeam(sl()));
  sl.registerLazySingleton<InvitePlayerToTeam>(() => InvitePlayerToTeam(sl()));
  sl.registerLazySingleton<KickPlayer>(() => KickPlayer(sl(), sl()));
  sl.registerLazySingleton<RequestAccept>(() => RequestAccept(sl()));
  sl.registerLazySingleton<RequestToJoinTeam>(() => RequestToJoinTeam(sl()));
}
