// home_view_body.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_pocket/features/home/presentation/manager/cubits/home_cubit/home_cubit.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/home_content.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/home_skelton.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        switch (state.status) {
          case HomeStatus.initial:
            return const SizedBox.shrink();

          case HomeStatus.loading:
            // Show a shimmer placeholder layout
            return const HomeLoadingShimmer();

          case HomeStatus.error:
            return Center(
              child: Text(
                'Error: ${state.errorMessage}',
                style: const TextStyle(color: Colors.red),
              ),
            );

          case HomeStatus.success:
            if (state.homeEntity == null) {
              return const Center(child: Text('No data found'));
            } else {
              return HomeContent(homeEntity: state.homeEntity!);
            }
        }
      },
    );
  }
}
