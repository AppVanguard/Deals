import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/core/service/get_it_service.dart';
import 'package:deals/features/auth/domain/repos/user_repo.dart';
import 'package:deals/features/auth/presentation/manager/cubits/user_update_cubit/user_update_cubit.dart';
import 'package:deals/features/auth/presentation/views/widgets/user_update_bloc_consumer.dart';

class UserUpdateView extends StatelessWidget {
  const UserUpdateView({
    super.key,
    required this.id,
  });
  final String id;

  static const routeName = '/user_update';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserUpdateCubit(userRepo: getIt.get<UserRepo>()),
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: UserUpdateBlocConsumer(id: id),
      ),
    );
  }
}
