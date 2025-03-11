import 'package:deals/core/widgets/build_custom_error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

          child: _buildContent(context, state, isLoading),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, HomeState state, bool isLoading) {
    if (state is HomeInitial) {
      // Scrollable empty placeholder
      return ListView();
    } else if (state is HomeLoading) {
      return HomeContent(
        homeEntity: null,
        isLoading: isLoading,
      );
    } else if (state is HomeFailure) {
      // Wrap the error message in a scrollable view
      return ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          buildCustomErrorScreen(
              context: context,
              onRetry: () {
                context.read<HomeCubit>().fetchHomeData(isRefresh: true);
              }),
        ],
      );
    } else if (state is HomeSuccess) {
      return HomeContent(
        homeEntity: state.homeEntity,
        isLoading: isLoading,
      );
    } else {
      // Fallback scrollable empty widget
      return ListView();
    }
  }

  
}
