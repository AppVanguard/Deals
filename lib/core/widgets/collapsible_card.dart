import 'package:flutter/material.dart';

class CollapsibleCard extends StatelessWidget {
  final Widget title;
  final List<Widget> children;
  final bool initiallyExpanded;

  const CollapsibleCard({
    super.key,
    required this.title,
    required this.children,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        // Remove the default divider line
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: title,
          iconColor: const Color(0xFF04832D),
          collapsedIconColor: const Color(0xFF04832D),
          children: children,
        ),
      ),
    );
  }
}
