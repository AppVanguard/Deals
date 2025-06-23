import 'package:deals/core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/core/widgets/error_message_card.dart';
import 'package:deals/features/privacy_and_policy/presentation/manager/cubits/privacy_policy_cubit/privacy_policy_cubit.dart';

class PrivacyAndPolicyViewBody extends StatelessWidget {
  const PrivacyAndPolicyViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrivacyPolicyCubit, PrivacyPolicyState>(
      builder: (context, state) {
        if (state is PrivacyPolicyLoading || state is PrivacyPolicyInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PrivacyPolicyFailure) {
          return Center(
            child: ErrorMessageCard(
              title: 'Failed to load policy',
              message: 'Please check your connection and try again.',
              onRetry: () => context.read<PrivacyPolicyCubit>().loadPolicy(),
            ),
          );
        } else if (state is PrivacyPolicySuccess) {
          final terms = state.terms;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              children: [
                SvgPicture.asset(AppImages.assetsImagesPrivacy),
                const SizedBox(height: 24),
                ...terms.map((t) => _BulletItem(text: t)),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  const _BulletItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•', style: TextStyle(fontSize: 20, height: 1.4)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
