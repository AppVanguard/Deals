import 'package:deals/core/utils/app_images.dart';
import 'package:deals/core/widgets/error_message_card.dart';
import 'package:deals/features/privacy_and_policy/presentation/manager/cubits/privacy_policy_cubit/privacy_policy_cubit.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Shows the privacy policy content or an error message when loading fails.
class PrivacyAndPolicyViewBody extends StatelessWidget {
  const PrivacyAndPolicyViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return BlocBuilder<PrivacyPolicyCubit, PrivacyPolicyState>(
      builder: (context, state) {
        if (state is PrivacyPolicyLoading || state is PrivacyPolicyInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PrivacyPolicyFailure) {
          return Center(
            child: ErrorMessageCard(
              title: S.of(context).FaildToLoadPrivaceAndPolicy,
              message: S.of(context).CheckConnectionError,
              onRetry: () => context.read<PrivacyPolicyCubit>().loadPolicy(),
            ),
          );
        } else if (state is PrivacyPolicySuccess) {
          final sections = state.document.sections;

          return Directionality(
            textDirection: TextDirection.ltr,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SvgPicture.asset(
                      AppImages.assetsImagesPrivacy,
                    ),
                  ),
                  const SizedBox(height: 24),
                  for (var sec in sections) ...[
                    // Section title
                    Text(
                      sec.title,
                      style: theme.titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // Paragraphs
                    for (var p in sec.paragraphs) ...[
                      Text(p, style: theme.bodyLarge),
                      const SizedBox(height: 12),
                    ],

                    // Bullets
                    for (var b in sec.bullets) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ',
                                style: TextStyle(fontSize: 16, height: 1.4)),
                            Expanded(child: Text(b, style: theme.bodyMedium)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],

                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
