import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_pocket/core/service/get_it_service.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/features/auth/domain/entities/user_entity.dart';
import 'package:in_pocket/features/home/domain/repos/home_repo.dart';
import 'package:in_pocket/features/home/presentation/manager/cubits/home_cubit/home_cubit.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/build_home_app_bar.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/custom_app_drawer_bloc_provider.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/custom_bottom_navigation_bar.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.userData});
  static const String routeName = 'home';
  final UserEntity userData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(),
      appBar: buildHomeAppBar(context),
      drawer: CustomAppDrawerBlocProvider(
          userData: userData), // Use your custom drawer here
      body: BlocProvider(
        create: (context) => HomeCubit(homeRepo: getIt<HomeRepo>()),
        child: const HomeViewBody(),
      ),
    );
  }
}
