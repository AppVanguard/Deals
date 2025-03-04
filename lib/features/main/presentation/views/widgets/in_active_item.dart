import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

class InActiveItem extends StatelessWidget {
  const InActiveItem({super.key, required this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(image);
  }
}
