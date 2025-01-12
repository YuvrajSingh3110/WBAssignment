import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:task_app/core/network/connecttion_checker.dart';
import 'package:task_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:task_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:task_app/features/auth/domain/repository/auth_repository.dart';
import 'package:task_app/features/auth/domain/usecases/current_user.dart';
import 'package:task_app/features/auth/domain/usecases/user_login.dart';
import 'package:task_app/features/auth/domain/usecases/user_signup.dart';
import 'package:task_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_app/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:task_app/features/todo/data/datasources/todo_remote_data_source.dart';
import 'package:task_app/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:task_app/features/todo/domain/repositories/todo_repository.dart';
import 'package:task_app/features/todo/domain/usecases/delete_todo.dart';
import 'package:task_app/features/todo/domain/usecases/get_all_todos.dart';
import 'package:task_app/features/todo/domain/usecases/upload_todo.dart';
import 'package:task_app/features/todo/presentation/bloc/todo_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initTodo();
  await Firebase.initializeApp();
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  //we use singleton to have only 1 instance of firebaseAuth globally
  serviceLocator.registerLazySingleton(() => firebaseAuth);
  serviceLocator.registerLazySingleton(() => firebaseFirestore);

  serviceLocator.registerLazySingleton(
    () => Hive.box(name: 'todos'),
  );

  //internet connection
  serviceLocator.registerFactory(() => InternetConnection());

  //core
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );
}

void _initAuth() {
  //in this case we want a new instance every time this is called
  //return type is AuthRemoteDataSource
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(serviceLocator()))
    //return type is AuthRepository
    ..registerFactory<AuthRepository>(
        () => AuthRepositoryImpl(serviceLocator()))
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    //we have to use only 1 instance of authBloc so that app does not get confused between multiple blocs
    ..registerLazySingleton(
      () => AuthBloc(
        userSignup: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initTodo() {
  // Datasource
  serviceLocator
    ..registerFactory<TodoRemoteDataSource>(
      () => TodoRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<TodoLocalDataSource>(
      () => TodoLocalDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<TodoRepository>(
      () => TodoRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => UploadTodo(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllTodos(
        serviceLocator(),
      ),
    )..registerFactory(
      () => DeleteTodo(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => TodoBloc(
        uploadTodo: serviceLocator(),
        getAllTodos: serviceLocator(),
        deleteTodo: serviceLocator(),
      ),
    );
}
