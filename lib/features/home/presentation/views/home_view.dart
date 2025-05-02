// lib/features/home/presentation/views/home_view.dart

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/features/home/presentation/views/widgets/build_home_app_bar.dart';
import 'package:deals/features/home/presentation/views/widgets/custom_app_drawer_bloc_provider.dart';
import 'package:deals/features/home/presentation/views/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.userData});
  static const String routeName = '/home';

  final UserEntity userData;

  @override
  Widget build(BuildContext context) {
    log("User Data: ${userData.uId}");
    return Scaffold(
      appBar: buildHomeAppBar(context: context, userData: userData),
      drawer: CustomAppDrawerBlocProvider(userData: userData),
      body: const HomeViewBody(),
    );
  }
}
