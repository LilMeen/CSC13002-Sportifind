import 'package:get_it/get_it.dart';
import 'package:sportifind/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:sportifind/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:sportifind/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:sportifind/features/auth/domain/repositories/auth_repository.dart';
import 'package:sportifind/features/auth/domain/usecases/forgot_password.dart';
import 'package:sportifind/features/auth/domain/usecases/sign_in.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:sportifind/features/auth/domain/usecases/sign_up.dart';
import 'package:sportifind/features/auth/domain/usecases/sign_out.dart';
import 'package:sportifind/features/auth/domain/usecases/set_role.dart';
import 'package:sportifind/features/auth/domain/usecases/set_basic_info.dart';


final GetIt sl = GetIt.instance;

void initializeDependencies (){ 
  
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl()
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl()
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(), 
      localDataSource: sl(),
    )
  );

  // Use cases
  sl.registerLazySingleton<SignIn>(() => SignIn(sl()));
  sl.registerLazySingleton<SignInWithGoogle>(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton<SignUp>(() => SignUp(sl()));
  sl.registerLazySingleton<SignOut>(() => SignOut(sl()));
  sl.registerLazySingleton<ForgotPassword>(() => ForgotPassword(sl()));
  sl.registerLazySingleton<SetRole>(() => SetRole(sl()));
  sl.registerLazySingleton<SetBasicInfo>(() => SetBasicInfo(sl()));
}


