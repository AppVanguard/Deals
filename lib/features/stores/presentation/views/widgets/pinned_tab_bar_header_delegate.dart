import 'package:flutter/material.dart';

/// Simple persistent header delegate that pins a [TabBar] at a fixed height.
class TabBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  /// Widget to display as the tab bar.
  TabBarHeaderDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => 48.0;
  @override
  double get maxExtent => 48.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(TabBarHeaderDelegate oldDelegate) => false;
}
