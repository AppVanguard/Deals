// lib/core/widgets/filter_dialog/dynamic_radio_group.dart

import 'package:deals/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'custom_radio_option.dart';

class DynamicRadioGroup<T> extends StatelessWidget {
  final String title;
  final List<T> options;
  final T selected;
  final ValueChanged<T> onChanged;
  final String Function(T) labelBuilder;
  final double optionSpacing;

  const DynamicRadioGroup({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.onChanged,
    required this.labelBuilder,
    this.optionSpacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.bold14),
        const SizedBox(height: 16),
        ...options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          // Only add spacing below items, not after the last one.
          final bottomSpacing =
              (index == options.length - 1) ? 0.0 : optionSpacing;

          return Padding(
            padding: EdgeInsets.only(bottom: bottomSpacing),
            child: CustomRadioOption(
              label: labelBuilder(option),
              selected: option == selected,
              onTap: () => onChanged(option),
            ),
          );
        }),
      ],
    );
  }
}
