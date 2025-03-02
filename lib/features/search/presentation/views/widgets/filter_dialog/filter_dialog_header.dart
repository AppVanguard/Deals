// lib/features/search/presentation/views/filter_dialog/filter_dialog_header.dart

import 'package:deals/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class FilterDialogHeader extends StatelessWidget {
  const FilterDialogHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // No border here. Let the dialog's rounded corners show.
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      child: const Center(
        child: Text('Filters', style: AppTextStyles.bold16),
      ),
    );
  }
}
