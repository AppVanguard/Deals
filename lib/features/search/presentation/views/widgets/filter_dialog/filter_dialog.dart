import 'package:deals/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'filter_option.dart';
import 'filter_dialog_header.dart';
import 'filter_dialog_actions.dart';
import 'dynamic_radio_group.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  FilterOption _selectedFilter = FilterOption.cashbackAndCoupons;
  OrderOption _selectedOrder = OrderOption.lowToHigh;

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get screen height and constrain the dialog size.
    final screenHeight = MediaQuery.of(context).size.height;
    // The dialog will take up to 80% of the screen height if needed.
    final maxHeight = screenHeight * 0.8;

    return Dialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide.none,
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
                  title: 'Offers',
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
                  title: 'Ordered by',
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
                  // TODO: Implement filter logic if needed.
                  Navigator.pop(context);
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
