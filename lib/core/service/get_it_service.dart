import 'package:get_it/get_it.dart';
import 'package:in_pocket/core/service/auth_api_service.dart';
import 'package:in_pocket/core/service/database_service.dart';
import 'package:in_pocket/core/service/firebase_auth_service.dart';
import 'package:in_pocket/core/service/firestore_services.dart';
import 'package:in_pocket/core/service/user_service.dart';
import 'package:in_pocket/features/auth/data/repos/auth_repo_impl.dart';
import 'package:in_pocket/features/auth/domain/repos/auth_repo.dart';
import 'package:in_pocket/features/auth/data/repos/user_repo_impl.dart';
import 'package:in_pocket/features/auth/domain/repos/user_repo.dart';
import 'package:in_pocket/features/home/data/repos/home_repo_impl.dart';
import 'package:in_pocket/features/home/data/repos/menu_repo_impl.dart';
import 'package:in_pocket/features/home/domain/repos/home_repo.dart';
import 'package:in_pocket/features/home/domain/repos/menu_repo.dart';
import 'package:in_pocket/features/home/services/home_api_service.dart';

final getIt = GetIt.instance;
void setupGetit() {
  // Existing registrations.
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  getIt.registerSingleton<DatabaseService>(FirestoreServices());
  getIt.registerSingleton<AuthApiService>(AuthApiService());
  getIt.registerSingleton<AuthRepo>(AuthRepoImpl(
    authApiService: getIt<AuthApiService>(),
    firebaseAuthService: getIt<FirebaseAuthService>(),
  ));

  // Register user service and repository.
  getIt.registerSingleton<UserService>(UserService());
  getIt.registerSingleton<UserRepo>(
      UserRepoImpl(userService: getIt<UserService>()));
  getIt.registerSingleton<MenuRepo>(
      MenuRepoImpl(authApiService: getIt<AuthApiService>()));
  getIt.registerSingleton<HomeService>(HomeService());
  getIt.registerSingleton<HomeRepo>(
      HomeRepoImpl(homeService: getIt<HomeService>()));
}
