// get_it_service.dart
import 'package:deals/core/repos/implementation/categories_repo_impl.dart';
import 'package:deals/core/repos/interface/categories_repo.dart';
import 'package:deals/core/service/category_service.dart';
import 'package:deals/core/service/stores_api_service.dart';
import 'package:deals/features/stores/data/repos/stores_repo_impl.dart';
import 'package:deals/features/stores/domain/repos/stores_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:deals/core/service/auth_api_service.dart';
import 'package:deals/core/service/firebase_auth_service.dart';
import 'package:deals/core/service/user_service.dart';
import 'package:deals/features/auth/data/repos/auth_repo_impl.dart';
import 'package:deals/features/auth/domain/repos/auth_repo.dart';
import 'package:deals/features/auth/data/repos/user_repo_impl.dart';
import 'package:deals/features/auth/domain/repos/user_repo.dart';
import 'package:deals/features/home/data/repos/home_repo_impl.dart';
import 'package:deals/features/home/data/repos/menu_repo_impl.dart';
import 'package:deals/features/home/domain/repos/home_repo.dart';
import 'package:deals/features/home/domain/repos/menu_repo.dart';
import 'package:deals/core/service/home_api_service.dart';
import 'package:deals/core/service/shared_prefrences_singleton.dart'; // import Prefs
import 'package:deals/features/home/data/datasources/home_local_data_source.dart';

final getIt = GetIt.instance;

void setupGetit() {
  // 1. Existing singletons
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  getIt.registerSingleton<AuthApiService>(AuthApiService());
  getIt.registerSingleton<StoresService>(StoresService());
  getIt.registerSingleton<CategoriesService>(CategoriesService());

  getIt.registerSingleton<AuthRepo>(
    AuthRepoImpl(
      authApiService: getIt<AuthApiService>(),
      firebaseAuthService: getIt<FirebaseAuthService>(),
    ),
  );

  getIt.registerSingleton<UserService>(UserService());
  getIt.registerSingleton<UserRepo>(
    UserRepoImpl(userService: getIt<UserService>()),
  );
  getIt.registerSingleton<MenuRepo>(
    MenuRepoImpl(authApiService: getIt<AuthApiService>()),
  );
  getIt.registerSingleton<HomeService>(HomeService());

  // 2. The new local data source, passing Prefs.prefs
  getIt.registerSingleton<HomeLocalDataSource>(
    HomeLocalDataSource(Prefs.prefs),
  );

  // 3. The HomeRepo that depends on both remote service & local data source
  getIt.registerSingleton<HomeRepo>(
    HomeRepoImpl(
      homeService: getIt<HomeService>(),
      localDataSource: getIt<HomeLocalDataSource>(),
    ),
  );
  getIt.registerSingleton<StoresRepo>(
    StoresRepoImpl(
      storesService: getIt<StoresService>(),
    ),
  );
  getIt.registerSingleton<CategoriesRepo>(
    CategoriesRepoImpl(
      categoriesService: getIt<CategoriesService>(),
    ),
  );
}
