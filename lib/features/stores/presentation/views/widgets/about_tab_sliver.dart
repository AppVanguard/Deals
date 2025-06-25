import 'package:flutter/material.dart';
import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';

/// “About” tab displaying store description and extra info.
class AboutTabSliver extends StatelessWidget {
  const AboutTabSliver({
    super.key,
    required this.storeEntity,
    required this.isLoading,
  });

  final StoreEntity? storeEntity;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    // If still loading => placeholder
    if (isLoading && storeEntity == null) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Loading about info...',
            style: AppTextStyles.semiBold14,
          ),
        ),
      );
    }

    final title = storeEntity?.title ?? 'Store';
    final desc = storeEntity?.description ?? 'No Description';

    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 200, top: 10),
      sliver: SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: AppColors.tertiaryText,
                spreadRadius: 3,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "About $title",
                  style: AppTextStyles.bold16.copyWith(
                    color: AppColors.primary,
                    letterSpacing: 0.8,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  desc,
                  style: AppTextStyles.regular16.copyWith(
                    color: Colors.grey.shade800,
                    height: 1.6,
                    wordSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
