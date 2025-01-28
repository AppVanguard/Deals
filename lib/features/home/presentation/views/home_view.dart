import 'package:flutter/material.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const String routeName = 'home';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: Drawer(),
      body: HomeViewBody(),
    );
  }
}
