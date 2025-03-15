import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class AboutTab extends StatelessWidget {
  const AboutTab({super.key, this.storeEntity});
  final StoreEntity? storeEntity;
  @override
  Widget build(BuildContext context) {
    // Description or "About" info
    return Container(
      constraints: const BoxConstraints(minHeight: 100),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 5,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${storeEntity!.title} :",
              style:
                  AppTextStyles.semiBold14.copyWith(color: AppColors.primary),
            ),
            Text(
              storeEntity!.description!,
              style: AppTextStyles.regular14,
            ),
          ],
        ),
      ),
    );
  }
}
