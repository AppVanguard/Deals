import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/core/widgets/custom_error_screen.dart';
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
          GenericErrorScreen(
            title: 'Oops, something went wrong!',
            message:
                'We encountered an unexpected error while processing your request.',
            errorDetails: 'Error Code: 500 - Internal Server Error',
            onRetry: () {
              context.read<HomeCubit>().fetchHomeData(isRefresh: true);
            },
            retryButtonText: 'Try Again',
            // Optionally override the default error illustration
            errorIllustration: const Icon(
              Icons.cloud_off,
              size: 80,
              color: Colors.orangeAccent,
            ),
            // Optionally provide a Lottie animation (this overrides errorIllustration if provided)
            lottieAnimationAsset: 'assets/animations/error.json',
            // Customize the background gradient
            gradientColors: const [AppColors.background, AppColors.background],
            backgroundColor: AppColors.primary,
            // Optional footer widget
            footer: const Text(
              'If the issue persists, please contact our support team.',
              textAlign: TextAlign.center,
              style: AppTextStyles.regular16,
            ),
          ),
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
