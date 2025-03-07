// lib/features/search/presentation/views/filter_dialog/filter_dialog_actions.dart

import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';

class FilterDialogActions extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onShowResults;

  const FilterDialogActions({
    super.key,
    required this.onReset,
    required this.onShowResults,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: onReset,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(S.of(context).Reset, style: AppTextStyles.bold14),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: onShowResults,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF00AD37),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    S.of(context).ShowResults,
                    style: AppTextStyles.bold14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
