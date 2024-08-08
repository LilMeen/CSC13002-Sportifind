import 'package:get_it/get_it.dart';
import 'package:sportifind/features/stadium/data/datasources/stadium_remote_data_source.dart';
import 'package:sportifind/features/stadium/data/repositories/stadium_repository_impl.dart';
import 'package:sportifind/features/stadium/domain/repositories/stadium_repository.dart';
import 'package:sportifind/features/stadium/domain/usecases/create_stadium.dart';

final GetIt sl = GetIt.instance;

void initializeStadiumDependencies (){ 
  
  // Data sources
  sl.registerLazySingleton<StadiumRemoteDataSource>(
    () => StadiumRemoteDataSourceImpl()
  );

  // Repositories
  sl.registerLazySingleton<StadiumRepository>(
    () => StadiumRepositoryImpl(
      stadiumRemoteDataSource: sl(), 
    )
  );

  // Use cases
  sl.registerLazySingleton<CreateStadium>(() => CreateStadium(sl()));
}


