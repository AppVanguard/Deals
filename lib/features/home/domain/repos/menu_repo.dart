import 'package:dartz/dartz.dart';
import 'package:in_pocket/core/errors/faliure.dart';

abstract class MenuRepo {
  Future<Either<Failure, String>> logOut({required String firebaseUid});
}
