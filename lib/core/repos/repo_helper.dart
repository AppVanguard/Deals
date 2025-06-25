import 'package:deals/core/utils/dev_log.dart';
import 'package:dartz/dartz.dart';
import 'package:deals/core/errors/exception.dart';
import 'package:deals/core/errors/failure.dart';
import 'package:deals/generated/l10n.dart';

/// Mixin providing a standardized error handling wrapper for repository calls.
mixin RepoHelper {
  /// Executes [action] and converts thrown [CustomException]s or other errors
  /// into [Failure] instances.
  Future<Either<Failure, T>> run<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } on CustomException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e, s) {
      log('Repo error', error: e, stackTrace: s);
      return Left(ServerFailure(message: S.current.SomethingWentWrong));
    }
  }
}
