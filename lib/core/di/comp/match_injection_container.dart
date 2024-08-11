import 'package:get_it/get_it.dart';
import 'package:sportifind/features/match/data/datasources/match_remote_data_source.dart';

final GetIt sl = GetIt.instance;

void initializeMatchDependencies (){ 
  
  // Data sources
  sl.registerLazySingleton<MatchRemoteDataSource>(
    () => MatchRemoteDataSourceImpl()
  );

  // Repositories


  // Use cases

}