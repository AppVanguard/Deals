// lib/core/widgets/filter_dialog/dynamic_radio_group.dart

import 'package:deals/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'custom_radio_option.dart';

/// Generic list of radio options with a configurable label builder.
///
/// [T] is the value type of each option. The widget displays each item using
/// [labelBuilder] and notifies [onChanged] when the selection updates.

class DynamicRadioGroup<T> extends StatelessWidget {
  /// Heading text above the options list.
  final String title;

  /// Available values to choose from.
  final List<T> options;

  /// Currently selected value.
  final T selected;

  /// Callback when the user selects a new option.
  final ValueChanged<T> onChanged;

  /// Builds a string label from each option item.
  final String Function(T) labelBuilder;

  /// Vertical spacing between options.
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
