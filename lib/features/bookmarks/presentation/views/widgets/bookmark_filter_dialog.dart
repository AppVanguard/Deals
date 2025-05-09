import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/generated/l10n.dart';
import 'package:deals/core/manager/cubit/category_cubit/categories_cubit.dart';
import 'package:deals/core/widgets/filter_dialog/filter_dialog_header.dart';
import 'package:deals/core/widgets/filter_dialog/filter_dialog_actions.dart';
import 'package:deals/core/widgets/filter_dialog/dynamic_radio_group.dart';
import 'package:deals/core/widgets/filter_dialog/filter_option.dart';

class BookmarkFilterDialog extends StatefulWidget {
  const BookmarkFilterDialog({
    super.key,
    required this.initialCategories,
    required this.initialHasCoupons,
    required this.initialHasCashback,
    required this.initialOrder,
    required this.onApply,
  });

  final List<String> initialCategories;
  final bool initialHasCoupons;
  final bool initialHasCashback;
  final String initialOrder; // "asc" | "desc"
  final void Function(
    List<String> categories,
    String sortOrder,
    bool hasCoupons,
    bool hasCashback,
  ) onApply;

  @override
  State<BookmarkFilterDialog> createState() => _BookmarkFilterDialogState();
}

class _BookmarkFilterDialogState extends State<BookmarkFilterDialog> {
  late List<String> _catIds;
  late OrderOption _order;
  late FilterOption _offer;

  @override
  void initState() {
    super.initState();
    _catIds = List.of(widget.initialCategories);
    _order = widget.initialOrder == 'desc'
        ? OrderOption.highToLow
        : OrderOption.lowToHigh;
    _offer = widget.initialHasCoupons
        ? FilterOption.coupons
        : widget.initialHasCashback
            ? FilterOption.cashback
            : FilterOption.cashbackAndCoupons;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final catState = context.watch<CategoriesCubit>().state;
    final cats = catState is CategoriesSuccess ? catState.categories : [];

    return Dialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FilterDialogHeader(),
            const Divider(height: 1, thickness: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: _buildCategorySection(cats, l10n),
            ),
            const Divider(height: 1, thickness: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: DynamicRadioGroup<FilterOption>(
                title: l10n.Offers,
                options: FilterOption.values,
                selected: _offer,
                onChanged: (f) => setState(() => _offer = f),
                labelBuilder: (o) => o.label,
              ),
            ),
            const Divider(height: 1, thickness: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: DynamicRadioGroup<OrderOption>(
                title: l10n.Ordered_by,
                options: OrderOption.values,
                selected: _order,
                onChanged: (o) => setState(() => _order = o),
                labelBuilder: (o) => o.label,
              ),
            ),
            const Divider(height: 1, thickness: 1),
            FilterDialogActions(
              onReset: _reset,
              onShowResults: () {
                widget.onApply(
                  _catIds,
                  _order.value,
                  _offer == FilterOption.coupons,
                  _offer == FilterOption.cashback,
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  //──────────────────────── helpers ────────────────────────
  void _reset() => setState(() {
        _catIds.clear();
        _offer = FilterOption.cashbackAndCoupons;
        _order = OrderOption.lowToHigh;
      });

  Widget _buildCategorySection(List cats, S l10n) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(l10n.Category, style: AppTextStyles.bold14),
              const Spacer(),
              TextButton(
                onPressed: () => setState(
                    () => _catIds = cats.map<String>((e) => e.id).toList()),
                child: Text(l10n.Select_all),
              ),
              TextButton(
                onPressed: () => setState(() => _catIds.clear()),
                child: Text(l10n.Select_none),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...cats.map(
            (c) => CheckboxListTile(
              dense: true,
              value: _catIds.contains(c.id),
              activeColor: AppColors.primary,
              title: Text(c.title),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (_) => setState(() {
                _catIds.contains(c.id)
                    ? _catIds.remove(c.id)
                    : _catIds.add(c.id);
              }),
            ),
          ),
        ],
      );
}
