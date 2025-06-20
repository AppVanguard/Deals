import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/core/service/secure_storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Mixin that provides a helper to fetch the currently signed-in user.
///
/// If no user is found, the provided [failureStateBuilder] is emitted
/// with a standard "User not found" message.
///
/// Usage within a cubit:
/// ```dart
/// class ExampleCubit extends Cubit<ExampleState> with RequiresUser<ExampleState> {
///   Future<void> doSomething() async {
///     final user = await requireUser((msg) => ExampleFailure(message: msg));
///     if (user == null) return;
///     // use [user]...
///   }
/// }
/// ```
mixin RequiresUser<S> on Cubit<S> {
  /// Returns the current [UserEntity] if available, otherwise emits the
  /// failure state produced by [failureStateBuilder] and returns `null`.
  Future<UserEntity?> requireUser(S Function(String message) failureStateBuilder) async {
    final user = await SecureStorageService.getCurrentUser();
    if (user == null) {
      emit(failureStateBuilder('User not found'));
      return null;
    }
    return user;
  }
}
