import 'package:flutter/material.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/custom_app_drawer.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const String routeName = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        title: const Text('Home'),
      ),
      drawer: const CustomAppDrawer(), // Use your custom drawer here
      body: const HomeViewBody(),
    );
  }
}
