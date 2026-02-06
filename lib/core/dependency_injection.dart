

import 'package:a_and_w/features/auth/data/datasource/local_auth_datasource.dart';
import 'package:a_and_w/features/auth/data/datasource/remote_auth_datasource.dart';
import 'package:a_and_w/features/auth/data/repository_implementation/auth_repository_impl.dart';
import 'package:a_and_w/features/auth/domain/repository/auth_repository.dart';
import 'package:a_and_w/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:a_and_w/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:a_and_w/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:a_and_w/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:a_and_w/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:a_and_w/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:a_and_w/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

final locator = GetIt.instance;

Future<void> getitInit()async{

  //firebase
  locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance,);
  locator.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn(),);

  //secure_storage
  locator.registerLazySingleton<FlutterSecureStorage>(() => FlutterSecureStorage(),);

  //local data source
  locator.registerLazySingleton<LocalAuthDatasource>(() => LocalAuthDatasourceImpl(locator<FirebaseAuth>()),);

  //remote data sourcce
  locator.registerLazySingleton<RemoteAuthDataSource>(() => RemoteAuthDatasourceImpl(firebaseAuth: locator(), googleSignIn: locator()),);


  //repository
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: locator(), localAuthDatasource: locator()),);
  
  //use cases
  locator.registerLazySingleton<SignInWithEmailUseCase>(() => SignInWithEmailUseCase(locator()),);
  locator.registerLazySingleton<SignInWithGoogleUseCase>(() => SignInWithGoogleUseCase(locator()),);
  locator.registerLazySingleton<SignUpUseCase>(() => SignUpUseCase(locator()),);
  locator.registerLazySingleton<SignOutUseCase>(() => SignOutUseCase(locator()),);
  locator.registerLazySingleton<GetCurrentUserUseCase>(() => GetCurrentUserUseCase(locator()),);
  locator.registerLazySingleton<CheckAuthStatusUseCase>(() => CheckAuthStatusUseCase(locator()),);

  //bloc
  locator.registerFactory<AuthBloc>(() => AuthBloc(
    signInWithEmailUseCase: locator(),
    signInWithGoogleUseCase: locator(),
    signUpUseCase: locator(), 
    signOutUseCase: locator(),
    checkAuthStatusUseCase: locator(),
  ),);
}