import 'package:flutter/material.dart';
import 'package:deals/core/entities/bottom_navigation_bar_entity.dart';
import 'package:deals/features/main/presentation/views/widgets/active_item.dart';
import 'package:deals/features/main/presentation/views/widgets/in_active_item.dart';

class NavigationBarItem extends StatelessWidget {
  const NavigationBarItem(
      {super.key,
      required this.isSelected,
      required this.bottomNavigationBarEntity});
  final bool isSelected;
  final BottomNavicationBarEntity bottomNavigationBarEntity;
  @override
  Widget build(BuildContext context) {
    return isSelected
        ? ActiveItem(
            image: bottomNavigationBarEntity.activeImage,
            title: bottomNavigationBarEntity.name,
          )
        : InActiveItem(image: bottomNavigationBarEntity.inActiveImage);
  }
}
