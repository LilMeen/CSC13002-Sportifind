import 'package:get_it/get_it.dart';
import 'package:sportifind/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:sportifind/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:sportifind/features/profile/domain/repositories/profile_repository.dart';
import 'package:sportifind/features/profile/domain/usecases/get_all_player.dart';
import 'package:sportifind/features/profile/domain/usecases/get_all_stadium_owner.dart';
import 'package:sportifind/features/profile/domain/usecases/get_current_profile.dart';
import 'package:sportifind/features/profile/domain/usecases/get_player.dart';
import 'package:sportifind/features/profile/domain/usecases/get_stadium_owner.dart';


final GetIt sl = GetIt.instance;

void initializeProfileDependencies (){ 
  
  // Data sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl()
  );

  // Repositories
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      profileRemoteDataSource: sl(),
      teamRemoteDataSource: sl(),
      stadiumRemoteDataSource: sl(),
    )
  );

  // Use cases
  sl.registerLazySingleton<GetAllPlayer>(() => GetAllPlayer(sl()));
  sl.registerLazySingleton<GetPlayer>(() => GetPlayer(sl()));
  sl.registerLazySingleton<GetCurrentProfile>(() => GetCurrentProfile(sl()));
  sl.registerLazySingleton<GetAllStadiumOwner>(() => GetAllStadiumOwner(sl()));
  sl.registerLazySingleton<GetStadiumOwner>(() => GetStadiumOwner(sl()));
}



