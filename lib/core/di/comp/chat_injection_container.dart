import 'package:get_it/get_it.dart';
import 'package:sportifind/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:sportifind/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:sportifind/features/chat/domain/repositories/chat_repository.dart';
import 'package:sportifind/features/chat/domain/usecases/get_message_by_team.dart';
import 'package:sportifind/features/chat/domain/usecases/send_message.dart';


final GetIt sl = GetIt.instance;

void initializeChatDependencies (){ 
  
  // Data sources
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl()
  );

  // Repositories
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      chatRemoteDatasource: sl(), 
    )
  );

  // Use cases
  sl.registerLazySingleton<GetMessageByTeam>(() => GetMessageByTeam(sl()));
  sl.registerLazySingleton<SendMessage>(() => SendMessage(sl()));
}