import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/widgets/filter_dialog/dynamic_radio_group.dart';
import 'package:deals/core/widgets/filter_dialog/filter_dialog_actions.dart';
import 'package:deals/core/widgets/filter_dialog/filter_dialog_header.dart';
import 'package:deals/core/widgets/filter_dialog/filter_option.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Modal used on the coupons screen to select sort and filter options.
class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key, required this.onApplyFilter});
  final void Function(OrderOption selectedOrder, FilterOption selectedFilter)
      onApplyFilter;

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  FilterOption _selectedFilter = FilterOption.cashbackAndCoupons;
  OrderOption _selectedOrder = OrderOption.lowToHigh;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * 0.8;

    return Dialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FilterDialogHeader(),
              const Divider(height: 1, thickness: 1),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: DynamicRadioGroup<FilterOption>(
                  title: S.of(context).Offers,
                  options: FilterOption.values,
                  selected: _selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value;
                    });
                  },
                  labelBuilder: (option) => option.label,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: DynamicRadioGroup<OrderOption>(
                  title: S.of(context).Ordered_by,
                  options: OrderOption.values,
                  selected: _selectedOrder,
                  onChanged: (value) {
                    setState(() {
                      _selectedOrder = value;
                    });
                  },
                  labelBuilder: (option) => option.label,
                  optionSpacing: 8,
                ),
              ),
              FilterDialogActions(
                onReset: _resetFilters,
                onShowResults: () {
                  // Pass the selected filter to the callback and close the dialog.
                  widget.onApplyFilter(_selectedOrder, _selectedFilter);
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedFilter = FilterOption.cashbackAndCoupons;
      _selectedOrder = OrderOption.lowToHigh;
    });
  }
}
