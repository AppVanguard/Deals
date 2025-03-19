import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class AboutTab extends StatelessWidget {
  const AboutTab({super.key, this.storeEntity});
  final StoreEntity? storeEntity;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Add margin for shadow visibility
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 100,
          maxHeight: 400, // Set max height as needed
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "About ${storeEntity!.title}",
                style: AppTextStyles.bold16.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 0.8,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                storeEntity!.description!,
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
    );
  }
}
