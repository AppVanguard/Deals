import 'package:dartz/dartz.dart';
import 'package:deals/core/errors/faliure.dart';

abstract class MenuRepo {
  Future<Either<Failure, String>> logOut({required String firebaseUid});
}
