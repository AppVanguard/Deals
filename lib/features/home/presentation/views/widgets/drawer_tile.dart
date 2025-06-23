import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Reusable drawer tile used throughout the app drawer.
class DrawerTile extends StatelessWidget {
  const DrawerTile({
    super.key,
    required this.icon,
    required this.text,
    this.textStyle,
    this.onTap,
  });

  final String icon;
  final String text;
  final TextStyle? textStyle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(icon, height: 24, width: 24),
      title: Text(text, style: textStyle),
      onTap: onTap,
    );
  }
}
