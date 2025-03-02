import 'package:flutter/material.dart';
import 'package:deals/features/home/domain/entities/bottom_navigation_bar_entity.dart';
import 'package:deals/features/home/presentation/views/widgets/navigation_bar_item.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      // your decoration...
      child: Row(
        children: bottomNavigationBarList.asMap().entries.map((entry) {
          final index = entry.key;
          final entity = entry.value;
          return Expanded(
            flex: index == selectedIndex ? 3 : 2,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(index),
              child: NavigationBarItem(
                bottomNavigationBarEntity: entity,
                isSelected: selectedIndex == index,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
