import 'package:flutter/material.dart';

/// A reusable sliver section header with a "See All" link.
///
/// Displays the [title] on the left and the optional [onSeeAll]
/// callback on the right.
class SliverSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  final EdgeInsetsGeometry padding;
  final TextStyle? titleStyle;
  final String seeAllText;

  const SliverSectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.titleStyle,
    this.seeAllText = 'See All',
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: titleStyle ?? Theme.of(context).textTheme.titleMedium,
            ),
            if (onSeeAll != null)
              GestureDetector(
                onTap: onSeeAll,
                child: Text(
                  seeAllText,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
