import 'package:flutter/material.dart';
import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/generated/l10n.dart';

/// Tab describing cashback details and rates for a store.
class CashbackTabSliver extends StatefulWidget {
  const CashbackTabSliver({
    super.key,
    required this.storeEntity,
    required this.isLoading,
  });

  final StoreEntity? storeEntity;
  final bool isLoading;

  @override
  State<CashbackTabSliver> createState() => _CashbackTabSliverState();
}

class _CashbackTabSliverState extends State<CashbackTabSliver>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If still loading & no store data => placeholder
    if (widget.isLoading && widget.storeEntity == null) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Loading cashback info...'),
        ),
      );
    }

    final store = widget.storeEntity;
    final cashBackRate = store?.cashBackRate ?? 0.0;
    final terms = store?.terms ?? [];

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cashback rate row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).CashBackRate,
                  style: AppTextStyles.semiBold14,
                ),
                Text(
                  '${S.of(context).upTo} $cashBackRate% ${S.of(context).cashBack}',
                  style: AppTextStyles.semiBold14.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Expandable card for "Cashback terms"
            GestureDetector(
              onTap: _toggleExpand,
              child: Container(
                constraints: const BoxConstraints(minHeight: 56),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 5,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header row + arrow
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${S.of(context).cashbackTerms} :',
                            style: AppTextStyles.semiBold14.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          Icon(
                            _isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ],
                      ),
                    ),

                    // Animated expand/collapse section
                    SizeTransition(
                      sizeFactor: _expandAnimation,
                      axisAlignment: 1.0, // expand from top down
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: terms.isNotEmpty
                              ? terms.map((t) => Text('• $t')).toList()
                              : [
                                  Text(S.of(context).noCashbackTermsAvailable),
                                ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
