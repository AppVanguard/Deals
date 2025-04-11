import 'package:flutter/material.dart';

class TabBarHeaderDelegate extends SliverPersistentHeaderDelegate {
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
