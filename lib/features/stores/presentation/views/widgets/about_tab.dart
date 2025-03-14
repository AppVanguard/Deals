import 'package:deals/core/entities/store_entity.dart';
import 'package:flutter/material.dart';

class AboutTab extends StatelessWidget {
  const AboutTab({super.key, this.storeEntity});
  final StoreEntity? storeEntity;
  @override
  Widget build(BuildContext context) {
    // Description or "About" info
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About Alibaba",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
          "Vestibulum consectetur feugiat diam, et lobortis sapien "
          "consectetur a. Vestibulum ante ipsum primis in faucibus orci "
          "luctus et ultrices posuere cubilia curae;",
        ),
      ],
    );
  }
}
