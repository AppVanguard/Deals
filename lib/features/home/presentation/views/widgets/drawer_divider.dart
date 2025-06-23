import 'package:flutter/material.dart';

/// Simple wrapper widget around [Divider] to keep drawer code clean.
class DrawerDivider extends StatelessWidget {
  const DrawerDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(),
    );
  }
}
