import 'package:get_it/get_it.dart';
import 'package:in_pocket/core/service/auth_api_service.dart';
import 'package:in_pocket/core/service/database_service.dart';
import 'package:in_pocket/core/service/firebase_auth_service.dart';
import 'package:in_pocket/core/service/firestore_services.dart';
import 'package:in_pocket/features/auth/data/repos/auth_repo_impl.dart';
import 'package:in_pocket/features/auth/domain/repos/auth_repo.dart';

final getIt = GetIt.instance;
void setupGetit() {
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  getIt.registerSingleton<DatabaseService>(FirestoreServices());
  getIt.registerSingleton<AuthApiService>(AuthApiService());
  getIt.registerSingleton<AuthRepo>(AuthRepoImpl(
    authApiService: getIt<AuthApiService>(),
    backendStoreService: getIt<DatabaseService>(),
    firebaseAuthService: getIt<FirebaseAuthService>(),
  ));
}
