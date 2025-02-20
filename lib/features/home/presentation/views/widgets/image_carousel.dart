// image_carousel.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/core/utils/app_images.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final PageController _controller =
      PageController(viewportFraction: 0.8); // Set viewportFraction here
  final List<String> images = [
    AppImages.assetsImagesOnBoardingP1,
    AppImages.assetsImagesOnBoardingP2,
    AppImages.assetsImagesOnBoardingP3,
    AppImages.assetsImagesTest1,
    AppImages.assetsImagesTest2,
    AppImages.assetsImagesTest3
  ];
  late Timer _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Start the auto-scroll timer
  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentIndex == images.length - 1) {
        _controller.jumpToPage(0);
        _currentIndex = 0;
      } else {
        _controller.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _currentIndex++;
      }
    });
  }

  // Pause auto-scroll when user interacts with the carousel
  void _pauseAutoScroll() {
    _timer.cancel();
  }

  // Resume auto-scroll after user interaction stops for 2 seconds
  void _resumeAutoScroll() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!_timer.isActive) {
        _startAutoScroll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 146, // Set the height of the card to 146
          child: GestureDetector(
            onPanStart: (_) {
              _pauseAutoScroll(); // Pause auto-scroll when user interacts
            },
            onPanEnd: (_) {
              _resumeAutoScroll(); // Resume after user stops interacting
            },
            child: PageView.builder(
              controller: _controller,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      images[index],
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width *
                          0.8, // Set width to 80% of screen width
                    ),
                  ),
                );
              },
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
        // Dots Indicator below the carousel
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SmoothPageIndicator(
            controller: _controller,
            count: images.length,
            effect: WormEffect(
              activeDotColor: AppColors.primary,
              dotColor: AppColors.placeholder,
              dotHeight: 8.0,
              dotWidth: 8.0,
            ),
          ),
        ),
      ],
    );
  }
}
