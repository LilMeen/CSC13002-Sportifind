import 'package:get_it/get_it.dart';
import 'package:sportifind/features/notification/data/datasources/notification_remote_data_source.dart';

final GetIt sl = GetIt.instance;

void initializeNotificationDependencies (){ 
  
  // Data sources
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl()
  );

  // Repositories
  

  // Use cases
}