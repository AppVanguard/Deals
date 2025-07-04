import 'package:deals/core/repos/interface/notifications_permission_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/core/service/get_it_service.dart';
import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/features/home/domain/repos/menu_repo.dart';
import 'package:deals/features/home/presentation/manager/cubits/menu_cubit/menu_cubit.dart';
import 'package:deals/features/home/presentation/views/widgets/custom_app_drawer.dart';

/// Wraps [CustomAppDrawer] with a [BlocProvider] for [MenuCubit].

class CustomAppDrawerBlocProvider extends StatelessWidget {
  const CustomAppDrawerBlocProvider({
    super.key,
    required this.userData,
  });

  /// Data about the current user to pass down to the drawer.
  final UserEntity userData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuCubit(
          menuRepo: getIt.get<MenuRepo>(),
          notificationsPermissionRepo:
              getIt.get<NotificationsPermissionRepo>()),
      child: CustomAppDrawer(
        userData: userData,
      ),
    );
  }
}
