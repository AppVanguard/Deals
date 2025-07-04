import 'package:deals/core/entities/user_entity.dart';
import 'package:deals/core/helper_functions/build_custom_error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:deals/features/home/presentation/manager/cubits/home_cubit/home_cubit.dart';
import 'package:deals/features/home/presentation/views/widgets/home_content.dart';

/// Handles home data loading and pull-to-refresh logic.

class HomeViewBody extends StatelessWidget {
  /// Displays the refreshable home content for [user].
  const HomeViewBody({super.key, required this.user});

  /// Currently signed-in user.
  final UserEntity user;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final isLoading = state is HomeLoading;

        return RefreshIndicator(
          // Called when the user drags down to refresh
          onRefresh: () async {
            await context
                .read<HomeCubit>()
                .refresh(); // ← no token param needed
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
      if (state.errorMessage.contains('Invalid token')) {
        return const SizedBox.shrink();
      }
      return buildCustomErrorScreen(
        context: context,
        onRetry: () {
          context.read<HomeCubit>().refresh();
        },
        errorMessage: state.errorMessage,
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
