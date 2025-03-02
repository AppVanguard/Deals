import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/features/search/presentation/views/widgets/deal.dart';
import 'package:flutter/material.dart';

class DealCard extends StatelessWidget {
  final Deal deal;
  final VoidCallback? onTap;

  const DealCard({
    super.key,
    required this.deal,
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
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // Deal image.
            Container(
              width: 80,
              height: 80,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: AssetImage(deal.imagePath),
                  fit: BoxFit.cover,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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
                    deal.title,
                    style: const TextStyle(
                      color: Color(0xFF121212),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    deal.subtitle,
                    style: const TextStyle(
                      color: Color(0xFFE50300),
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow icon.
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
