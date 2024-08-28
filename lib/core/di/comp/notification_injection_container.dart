import 'package:get_it/get_it.dart';
import 'package:sportifind/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:sportifind/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:sportifind/features/notification/domain/repositories/notification_repository.dart';
import 'package:sportifind/features/notification/domain/usecases/get_notification.dart';
import 'package:sportifind/features/notification/domain/usecases/mark_as_read.dart';
import 'package:sportifind/features/notification/domain/usecases/match_request_accept.dart';
import 'package:sportifind/features/notification/domain/usecases/match_request_deny.dart';
import 'package:sportifind/features/notification/domain/usecases/team_request_accept.dart';
import 'package:sportifind/features/notification/domain/usecases/team_request_deny_team.dart';
import 'package:sportifind/features/notification/domain/usecases/team_request_deny_user.dart';

final GetIt sl = GetIt.instance;

void initializeNotificationDependencies() {
  // Data sources
  sl.registerLazySingleton<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl());

  // Repositories
  sl.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(notificationRemoteDataSource: sl()));

  // Use cases
  sl.registerLazySingleton<GetNotification>(() => GetNotification(sl()));
  sl.registerLazySingleton<MarkAsRead>(() => MarkAsRead(sl()));
  sl.registerLazySingleton<MatchRequestAccept>(() => MatchRequestAccept(sl()));
  sl.registerLazySingleton<MatchRequestDeny>(() => MatchRequestDeny(sl()));
  sl.registerLazySingleton<TeamRequestAccept>(() => TeamRequestAccept(sl()));
  sl.registerLazySingleton<TeamRequestDenyUser>(
      () => TeamRequestDenyUser(sl()));
  sl.registerLazySingleton<TeamRequestDenyTeam>(
      () => TeamRequestDenyTeam(sl()));
}
