import 'package:get_it/get_it.dart';
import 'package:sportifind/features/match/data/datasources/match_remote_data_source.dart';
import 'package:sportifind/features/match/data/repositories/match_repository_impl.dart';
import 'package:sportifind/features/match/domain/repositories/match_repository.dart';
import 'package:sportifind/features/match/domain/usecases/create_match.dart';
import 'package:sportifind/features/match/domain/usecases/delete_match.dart';
import 'package:sportifind/features/match/domain/usecases/delete_match_annouce.dart';
import 'package:sportifind/features/match/domain/usecases/get_all_match.dart';
import 'package:sportifind/features/match/domain/usecases/get_match.dart';
import 'package:sportifind/features/match/domain/usecases/get_match_by_field.dart';
import 'package:sportifind/features/match/domain/usecases/get_match_by_stadium.dart';
import 'package:sportifind/features/match/domain/usecases/get_nearby_match.dart';
import 'package:sportifind/features/match/domain/usecases/get_personal_match.dart';
import 'package:sportifind/features/match/domain/usecases/send_invitation_to_match.dart';
import 'package:sportifind/features/match/domain/usecases/send_request_to_join_match.dart';

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
      teamRemoteDataSource: sl(),
      notificationRemoteDataSource: sl(),
    )
  );

  // Use cases
  sl.registerLazySingleton<CreateMatch>(() => CreateMatch(sl()));
  sl.registerLazySingleton<GetAllMatch>(() => GetAllMatch(sl()));
  sl.registerLazySingleton<GetMatchByField>(() => GetMatchByField(sl()));
  sl.registerLazySingleton<GetMatchByStadium>(() => GetMatchByStadium(sl()));
  sl.registerLazySingleton<GetMatch>(() => GetMatch(sl()));
  sl.registerLazySingleton<GetPersonalMatch>(() => GetPersonalMatch(sl()));
  sl.registerLazySingleton<GetNearbyMatch>(() => GetNearbyMatch(sl()));
  sl.registerLazySingleton<DeleteMatch>(() => DeleteMatch(sl()));
  sl.registerLazySingleton<DeleteMatchAnnouce>(() => DeleteMatchAnnouce(sl()));
  
  sl.registerLazySingleton<SendRequestToJoinMatch>(() => SendRequestToJoinMatch(sl()));
  sl.registerLazySingleton<SendInvitationToMatch>(() => SendInvitationToMatch(sl()));
}