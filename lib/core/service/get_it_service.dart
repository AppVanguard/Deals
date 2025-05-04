// lib/core/service/get_it_service.dart

import 'package:deals/core/repos/implementation/notifications_permission_repo_impl.dart';
import 'package:deals/core/repos/interface/notifications_permission_repo.dart';
import 'package:deals/core/service/notifications_permission_service.dart';
import 'package:deals/features/personal_data/data/repos/presonal_data_repo_impl.dart';
import 'package:deals/features/settings/data/repos/settings_repo_impl.dart';
import 'package:deals/features/settings/domain/repos/settings_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:deals/core/repos/implementation/categories_repo_impl.dart';
import 'package:deals/core/repos/interface/categories_repo.dart';
import 'package:deals/core/service/category_service.dart';
import 'package:deals/core/service/coupons_service.dart';
import 'package:deals/core/service/notifications_service.dart';
import 'package:deals/core/service/stores_service.dart';
import 'package:deals/features/coupons/data/repos/coupons_repo_impl.dart';
import 'package:deals/features/coupons/domain/repos/coupons_repo.dart';
import 'package:deals/features/notifications/data/data_source/notifications_local_data_source.dart';
import 'package:deals/features/notifications/data/repos/notifiacation_repo_impl.dart';
import 'package:deals/features/notifications/domain/repos/notifications_repo.dart';
import 'package:deals/features/stores/data/repos/stores_repo_impl.dart';
import 'package:deals/features/stores/domain/repos/stores_repo.dart';
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
import 'package:deals/features/notifications/presentation/manager/cubits/notification_cubit/notifications_cubit.dart';

final GetIt getIt = GetIt.instance;

void setupGetit() {
  // 1. Register core services as lazy singletons.
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  getIt.registerSingleton<AuthApiService>(AuthApiService());
  getIt.registerSingleton<StoresService>(StoresService());
  getIt.registerSingleton<CategoriesService>(CategoriesService());
  getIt.registerSingleton<CouponsService>(CouponsService());
  getIt.registerSingleton<NotificationsService>(NotificationsService());

  // 2. Register Auth and User repositories.
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

  // 3. Register additional repositories.
  getIt.registerSingleton<MenuRepo>(
    MenuRepoImpl(authApiService: getIt<AuthApiService>()),
  );
  getIt.registerSingleton<HomeService>(HomeService());

  // 4. Register local data sources (using Prefs.prefs).
  getIt.registerSingleton<HomeLocalDataSource>(
    HomeLocalDataSource(Prefs.prefs),
  );

  // 5. Register HomeRepo.
  getIt.registerSingleton<HomeRepo>(
    HomeRepoImpl(
      homeService: getIt<HomeService>(),
      localDataSource: getIt<HomeLocalDataSource>(),
    ),
  );

  // 6. Register Notifications local data source and repositories.
  getIt.registerSingleton<NotificationsLocalDataSource>(
    NotificationsLocalDataSource(),
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
  getIt.registerSingleton<CouponsRepo>(
    CouponsRepoImpl(
      couponsService: getIt<CouponsService>(),
    ),
  );
  getIt.registerSingleton<NotificationsRepo>(
    NotificationsRepoImpl(
      service: getIt<NotificationsService>(),
      localDataSource: getIt<NotificationsLocalDataSource>(),
    ),
  );
  getIt.registerSingleton<NotificationsPermissionService>(
    NotificationsPermissionService(),
  );

  // Now register the new repo that wraps the service
  getIt.registerSingleton<NotificationsPermissionRepo>(
    NotificationsPermissionRepoImpl(
      service: getIt<NotificationsPermissionService>(),
    ),
  );

  getIt.registerSingleton<PersonalDataRepoImpl>(
    PersonalDataRepoImpl(
      userService: getIt<UserService>(),
    ),
  );
  getIt.registerSingleton<SettingsRepo>(
    SettingsRepoImpl(
      notificationsPermissionRepo: getIt<NotificationsPermissionRepo>(),
      authApiService: getIt<AuthApiService>(),
      userService: getIt<UserService>(),
    ),
  );
}

/// Called after a successful login, if we want the cubit
/// for that user's ID
void registerNotificationsCubitSingleton(String userId) {
  // Only register if not present
  if (!getIt.isRegistered<NotificationsCubit>()) {
    getIt.registerSingleton<NotificationsCubit>(
      NotificationsCubit(
        notificationsRepo: getIt<NotificationsRepo>(),
        userId: userId,
      ),
    );
  }
}

void unregisterNotificationsCubitSingleton() {
  // If it's registered, remove it.
  // You can wrap in a check, or just call 'unregister' –
  // but watch for if it's not registered at all.
  if (getIt.isRegistered<NotificationsCubit>()) {
    getIt.unregister<NotificationsCubit>();
  }
}
