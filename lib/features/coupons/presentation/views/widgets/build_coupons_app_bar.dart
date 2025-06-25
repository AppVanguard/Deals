import 'package:deals/core/utils/logger.dart';

import 'package:flutter/material.dart';

import 'package:deals/core/widgets/filter_dialog/filter_option.dart';
import 'package:deals/core/widgets/search_filter_app_bar.dart';
import 'package:deals/features/coupons/presentation/views/widgets/filter_dialog.dart';
import 'package:deals/generated/l10n.dart';

/// App bar for the coupons list with search and filter callbacks.
PreferredSizeWidget buildCouponsAppBar(
  BuildContext context,
  TextEditingController searchController, {
  required Function(String) onSearchChanged,
  required Function(String, String) onFilterChanged,
}) {
  return SearchFilterAppBar(
    controller: searchController,
    hintText: S.of(context).Search,
    onSearchChanged: onSearchChanged,
    onFilterTap: () {
      showDialog(
        context: context,
        builder: (c) => FilterDialog(
          onApplyFilter: (selectedOrder, selectedFilter) {
            appLog('selectedOrder: ${selectedOrder.value}');
            appLog('selectedFilter: ${selectedFilter.value}');
            onFilterChanged(
              selectedOrder.value,
              selectedFilter.value,
            );
          },
        ),
      );
    },
  );
}
