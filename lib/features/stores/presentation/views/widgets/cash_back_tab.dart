import 'package:deals/core/entities/store_entity.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_text_styles.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter/material.dart';

class CashbackTab extends StatefulWidget {
  const CashbackTab({super.key, this.storeEntity});
  final StoreEntity? storeEntity;

  @override
  State<CashbackTab> createState() => _CashbackTabState();
}

class _CashbackTabState extends State<CashbackTab>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    // Controls the duration and curve of the expand/collapse animation
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
    final terms = widget.storeEntity?.terms ?? [];
    // final terms = ["Cashback terms", "Cashback terms", "Cashback terms"];
    return Column(
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
              '${S.of(context).upTo} ${widget.storeEntity?.cashBackRate ?? ''}% ${S.of(context).cashBack}',
              style: AppTextStyles.semiBold14.copyWith(
                color: AppColors.accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Expandable card
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header row (Cashback terms) with arrow icon
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

                // Smoothly animated expand/collapse content
                SizeTransition(
                  sizeFactor: _expandAnimation,
                  axisAlignment: 1.0, // Align from the top down
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: terms.isNotEmpty
                          ? terms.map((term) => Text('• $term')).toList()
                          : [
                              // If no terms, show a fallback text or simply nothing
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
    );
  }
}
