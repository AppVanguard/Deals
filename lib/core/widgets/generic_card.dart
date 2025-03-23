import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            ),
          ],
        ),
        child: Row(
          children: [
            // Leading image with CachedNetworkImage
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl: imagePath,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Skeletonizer(
                    child: Container(
                      width: 80,
                      height: 80,
                      color: AppColors.lightGray,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.image,
                    size: 32,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Title and subtitle
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
                    style: AppTextStyles.semiBold12.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
            // Trailing icon
            Container(
              height: 24,
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
