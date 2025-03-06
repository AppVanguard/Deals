import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/features/home/presentation/manager/cubits/home_cubit/home_cubit.dart';
import 'package:deals/features/home/presentation/views/widgets/home_content.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final isLoading = state is HomeLoading;

        return RefreshIndicator(
          // Called when the user drags down to refresh
          onRefresh: () async {
            // Force a refresh in the Cubit
            await context.read<HomeCubit>().fetchHomeData(isRefresh: true);
          },
          // The child must be scrollable.
          // If `HomeContent` itself is not scrollable,
          // wrap it with a ListView or SingleChildScrollView.
          child: _buildContent(context, state, isLoading),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, HomeState state, bool isLoading) {
    if (state is HomeInitial) {
      // Show nothing or a placeholder
      return const SizedBox.shrink();
    } else if (state is HomeLoading) {
      // Show placeholders / skeleton UI
      return HomeContent(
        homeEntity: null,
        isLoading: isLoading,
      );
    } else if (state is HomeFailure) {
      // Show error
      return Center(
        child: Text(
          'Error: ${state.errorMessage}',
          style: const TextStyle(color: AppColors.accent),
        ),
      );
    } else if (state is HomeSuccess) {
      // If there's no data, show a fallback
      if (state.homeEntity == null) {
        return const Center(child: Text('No data found'));
      } else {
        // Show the data
        return HomeContent(
          homeEntity: state.homeEntity,
          isLoading: isLoading,
        );
      }
    } else {
      // Fallback if we encounter an unknown state
      return const SizedBox.shrink();
    }
  }
}
