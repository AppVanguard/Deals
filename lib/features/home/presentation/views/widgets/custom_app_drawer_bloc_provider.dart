import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_pocket/core/service/get_it_service.dart';
import 'package:in_pocket/features/auth/domain/entities/user_entity.dart';
import 'package:in_pocket/features/home/domain/repos/menu_repo.dart';
import 'package:in_pocket/features/home/presentation/manager/cubits/menu_cubit/menu_cubit.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/custom_app_drawer.dart';

class CustomAppDrawerBlocProvider extends StatelessWidget {
  const CustomAppDrawerBlocProvider({
    super.key,
    required this.userData,
  });

  final UserEntity userData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuCubit(menuRepo: getIt.get<MenuRepo>()),
      child: CustomAppDrawer(
        userData: userData,
      ),
    );
  }
}
