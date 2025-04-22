import 'package:flutter/material.dart';

/// مسافة رأسية ثابتة لسهولة قراءة الـ Column.
class VGap extends StatelessWidget {
  const VGap(this.height, {super.key});
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}
