import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_pocket/core/utils/app_images.dart';

class PageViewItem extends StatelessWidget {
  const PageViewItem({super.key, required this.image});
  final String image;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Image.asset(image // fit: BoxFit.cover,
              ),
        ),
      ],
    );
  }
}
