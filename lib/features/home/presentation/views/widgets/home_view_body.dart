// home_view_body.dart
import 'package:flutter/material.dart';
import 'package:in_pocket/generated/l10n.dart';
import 'image_carousel.dart'; // Import the ImageCarousel widget

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Header Text
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              S
                  .of(context)
                  .Save_money_with_us, // Assuming this is your localized string
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        // Image Carousel (using the extracted widget)
        SliverToBoxAdapter(
          child: ImageCarousel(),
        ),
      ],
    );
  }
}
