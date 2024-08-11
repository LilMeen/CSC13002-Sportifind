import 'package:get_it/get_it.dart';
import 'package:sportifind/features/team/data/datasources/team_remote_data_source.dart';

final GetIt sl = GetIt.instance;

void initializeTeamDependencies (){ 
  
  // Data sources
  sl.registerLazySingleton<TeamRemoteDataSource>(
    () => TeamRemoteDataSourceImpl()
  );

  // Repositories


  // Use cases

}