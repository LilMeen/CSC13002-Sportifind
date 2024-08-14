import 'package:get_it/get_it.dart';
import 'package:sportifind/features/team/data/datasources/team_remote_data_source.dart';
import 'package:sportifind/features/team/data/repositories/team_repository_impl.dart';
import 'package:sportifind/features/team/domain/repositories/team_repository.dart';
import 'package:sportifind/features/team/domain/usecases/get_team.dart';

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
    )
  );

  // Use cases
  sl.registerLazySingleton<GetTeam>(() => GetTeam(sl()));
}