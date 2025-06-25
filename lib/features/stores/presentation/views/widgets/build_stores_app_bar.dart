import 'package:deals/core/utils/logger.dart';

import 'package:flutter/material.dart';

import 'package:deals/core/widgets/filter_dialog/filter_option.dart';
import 'package:deals/core/widgets/search_filter_app_bar.dart';
import 'package:deals/features/stores/presentation/views/widgets/filter_dialog.dart';
import 'package:deals/generated/l10n.dart';

/// App bar used on the stores list screen with search and filter actions.
PreferredSizeWidget buildStoresAppBar(
  BuildContext context,
  TextEditingController searchController, {
  required Function(String) onSearchChanged,
  // New callback to notify the parent when filter options change.
  required Function(String) onFilterChanged,
}) {
  return SearchFilterAppBar(
    controller: searchController,
    hintText: S.of(context).Search,
    onSearchChanged: onSearchChanged,
    onFilterTap: () {
      showDialog(
        context: context,
        builder: (c) => FilterDialog(
          onApplyFilter: (selectedFilter) {
            appLog('Filter selected: ${selectedFilter.value}');
            onFilterChanged(selectedFilter.value);
          },
        ),
      );
    },
  );
}
