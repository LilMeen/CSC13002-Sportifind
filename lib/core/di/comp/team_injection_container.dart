import 'package:get_it/get_it.dart';
import 'package:sportifind/features/team/data/datasources/team_remote_data_source.dart';
import 'package:sportifind/features/team/data/repositories/team_repository_impl.dart';
import 'package:sportifind/features/team/domain/repositories/team_repository.dart';
import 'package:sportifind/features/team/domain/usecases/create_team.dart';
import 'package:sportifind/features/team/domain/usecases/get_team.dart';
import 'package:sportifind/features/team/domain/usecases/get_team_by_player.dart';

final GetIt sl = GetIt.instance;

void initializeTeamDependencies (){ 
  
  // Data sources
  sl.registerLazySingleton<TeamRemoteDataSource>(
    () => TeamRemoteDataSourceImpl()
  );

  // Repositories
  sl.registerLazySingleton<TeamRepository>(
    () => TeamRepositoryImpl(
      teamRemoteDataSource: sl(),
      profileRemoteDataSource: sl(),
      matchRemoteDataSource: sl(),
    )
  );

  // Use cases
  sl.registerLazySingleton<CreateTeam>(() => CreateTeam(sl()));
  sl.registerLazySingleton<GetTeam>(() => GetTeam(sl()));
  sl.registerLazySingleton<GetTeamByPlayer>(() => GetTeamByPlayer(sl()));
}