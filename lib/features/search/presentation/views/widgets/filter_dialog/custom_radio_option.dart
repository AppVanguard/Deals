import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomRadioOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const CustomRadioOption({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          // Outer circle with dynamic border color
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 2,
                color: selected ? AppColors.primary : Colors.black,
              ),
            ),
            // AnimatedSwitcher for the inner circle
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                // Scale transition for a nice 'pop' effect
                return ScaleTransition(scale: animation, child: child);
              },
              child: selected
                  ? Container(
                      key: const ValueKey<bool>(true),
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                    )
                  : const SizedBox(
                      key: ValueKey<bool>(false),
                      width: 0,
                      height: 0,
                    ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.regular14,
          ),
        ],
      ),
    );
  }
}
