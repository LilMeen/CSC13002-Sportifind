import 'package:get_it/get_it.dart';
import 'package:sportifind/features/user/data/datasources/user_remote_data_source.dart';
import 'package:sportifind/features/user/data/repositories/user_repository_impl.dart';
import 'package:sportifind/features/user/domain/repositories/user_repository.dart';
import 'package:sportifind/features/user/domain/usecases/delete_report.dart';
import 'package:sportifind/features/user/domain/usecases/delete_user.dart';
import 'package:sportifind/features/user/domain/usecases/get_all_report.dart';
import 'package:sportifind/features/user/domain/usecases/get_report.dart';
import 'package:sportifind/features/user/domain/usecases/get_user.dart';

final GetIt sl = GetIt.instance;

void initializeUserDependencies (){ 
  
  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl()
  );

  // Repositories
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      userRemoteDataSource: sl(),
      teamRemoteDataSource: sl(),
      profileRemoteDataSource: sl(),
      matchRemoteDataSource: sl(),
      stadiumRemoteDataSource: sl(),
    )
  );

  // Use cases
  sl.registerLazySingleton<DeleteReport>(() => DeleteReport(sl()));
  sl.registerLazySingleton<DeleteUser>(() => DeleteUser(sl()));
  sl.registerLazySingleton<GetAllReport>(() => GetAllReport(sl()));
  sl.registerLazySingleton<GetReport>(() => GetReport(sl()));
  sl.registerLazySingleton<GetUser>(() => GetUser(sl()));
}