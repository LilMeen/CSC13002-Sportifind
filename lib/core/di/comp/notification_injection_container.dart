import 'package:get_it/get_it.dart';
import 'package:sportifind/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:sportifind/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:sportifind/features/notification/domain/repositories/notification_repository.dart';

final GetIt sl = GetIt.instance;

void initializeNotificationDependencies (){ 
  
  // Data sources
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl()
  );

  // Repositories
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(notificationRemoteDataSource: sl())
  );

  // Use cases
}