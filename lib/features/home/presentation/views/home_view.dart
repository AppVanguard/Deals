import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/core/service/get_it_service.dart';
import 'package:deals/features/auth/domain/entities/user_entity.dart';
import 'package:deals/features/home/domain/repos/home_repo.dart';
import 'package:deals/features/home/presentation/manager/cubits/home_cubit/home_cubit.dart';
import 'package:deals/features/home/presentation/views/widgets/build_home_app_bar.dart';
import 'package:deals/features/home/presentation/views/widgets/custom_app_drawer_bloc_provider.dart';
import 'package:deals/features/home/presentation/views/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.userData});

  static const String routeName = 'home';

  final UserEntity userData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildHomeAppBar(context),
      drawer: CustomAppDrawerBlocProvider(userData: userData),
      body: BlocProvider(
        create: (_) => HomeCubit(
          homeRepo: getIt<HomeRepo>(),
        ),
        child: const HomeViewBody(),
      ),
    );
  }
}
