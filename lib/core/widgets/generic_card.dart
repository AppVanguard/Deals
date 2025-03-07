import 'package:deals/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:deals/core/utils/app_colors.dart';

class GenericCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final VoidCallback? onTap;

  const GenericCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 5,
            offset: Offset(0, 2),
            spreadRadius: 0,
          )
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            // Leading image.
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Title and subtitle.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bold14,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: AppTextStyles.semiBold12
                        .copyWith(color: AppColors.accent),
                  ),
                ],
              ),
            ),
            // Trailing icon.
            Container(
              height: 24,
              padding: const EdgeInsets.symmetric(vertical: 5),
              child:
                  const Icon(Icons.arrow_forward_ios, color: AppColors.accent),
            ),
          ],
        ),
      ),
    );
  }
}
