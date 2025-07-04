import 'package:flutter/material.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/entities/bottom_navigation_bar_entity.dart';
import 'package:deals/features/main/presentation/views/widgets/navigation_bar_item.dart';
/// Bottom navigation bar with rounded corners and animated items.
///
/// Takes the [selectedIndex] and notifies [onTap] when the user selects a
/// different tab. Each tab is built using [NavigationBarItem].


class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375, // You can change this to double.infinity if needed.
      height: 90,
      decoration: const ShapeDecoration(
        color: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 25,
            offset: Offset(0, -2),
          )
        ],
      ),
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
