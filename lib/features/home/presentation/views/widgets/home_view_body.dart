import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_pocket/features/home/presentation/manager/cubits/home_cubit/home_cubit.dart';
import 'package:in_pocket/features/home/presentation/views/widgets/home_content.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to the cubit's state changes
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final isLoading = (state.status == HomeStatus.loading);

        switch (state.status) {
          case HomeStatus.initial:
            // Show nothing or a placeholder
            return const SizedBox.shrink();

          case HomeStatus.loading:
            // Show the structure with placeholders
            return HomeContent(
              homeEntity: null,
              isLoading: isLoading,
            );

          case HomeStatus.error:
            // Show error
            return Center(
              child: Text(
                'Error: ${state.errorMessage}',
                style: const TextStyle(color: Colors.red),
              ),
            );

          case HomeStatus.success:
            // If we have no data for some reason
            if (state.homeEntity == null) {
              return const Center(
                child: Text('No data found'),
              );
            } else {
              return HomeContent(
                homeEntity: state.homeEntity!,
                isLoading: isLoading,
              );
            }
        }
      },
    );
  }
}
