import 'package:get_it/get_it.dart';
import 'package:sportifind/features/match/data/datasources/match_remote_data_source.dart';
import 'package:sportifind/features/match/data/repositories/match_repository_impl.dart';
import 'package:sportifind/features/match/domain/repositories/match_repository.dart';
import 'package:sportifind/features/match/domain/usecases/get_nearby_match.dart';
import 'package:sportifind/features/match/domain/usecases/get_personal_match.dart';

final GetIt sl = GetIt.instance;

void initializeMatchDependencies (){ 
  
  // Data sources
  sl.registerLazySingleton<MatchRemoteDataSource>(
    () => MatchRemoteDataSourceImpl()
  );

  // Repositories
  sl.registerLazySingleton<MatchRepository>(
    () => MatchRepositoryImpl(
      matchRemoteDataSource: sl(), 
      profileRemoteDataSource: sl(),
    )
  );

  // Use cases
  sl.registerLazySingleton<GetPersonalMatch>(() => GetPersonalMatch(sl()));
  sl.registerLazySingleton<GetNearbyMatch>(() => GetNearbyMatch(sl()));
}