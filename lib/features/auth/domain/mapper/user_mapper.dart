import 'package:deals/features/auth/data/models/user_model.dart';
import 'package:deals/features/auth/domain/entities/user_entity.dart';

class UserMapper {
  static UserEntity mapToEntitiy(UserModel model) {
    return UserEntity(
      email: model.email.toString(),
      name: model.fullName.toString(),
      phone: model.phone.toString(),
      token: model.token.toString(),
      uId: model.id.toString(),
    );
  }
}
