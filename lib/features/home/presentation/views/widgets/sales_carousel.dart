import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/features/home/domain/entities/announcement_entity.dart';
import 'package:in_pocket/features/home/domain/entities/home_entity.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SalesCarousel extends StatefulWidget {
  /// The dynamic list of announcements from your backend.
  final List<AnnouncementEntity> announcements;

  /// Auto-scroll interval in seconds.
  final int autoScrollSeconds;

  /// Transition animation duration between pages.
  final Duration transitionDuration;

  /// Fraction of the viewport each page should occupy (0.8 = 80%).
  final double viewportFraction;

  const SalesCarousel({
    Key? key,
    required this.announcements,
    this.autoScrollSeconds = 2,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.viewportFraction = 0.8,
  }) : super(key: key);

  @override
  State<SalesCarousel> createState() => _SalesCarouselState();
}

class _SalesCarouselState extends State<SalesCarousel> {
  late final PageController _controller;
  late Timer _timer;
  late int _currentIndex;
  late List<AnnouncementEntity> _data; // The actual list we'll show

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;

    // If no announcements found, build 4 placeholders
    _data = widget.announcements.isNotEmpty
        ? widget.announcements
        : _buildPlaceholderAnnouncements();

    _controller = PageController(viewportFraction: widget.viewportFraction);

    // Start the timer only if there's at least 1 item
    if (_data.isNotEmpty) {
      _startAutoScroll();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(
      Duration(seconds: widget.autoScrollSeconds),
      (timer) {
        if (_currentIndex == _data.length - 1) {
          _controller.jumpToPage(0);
          _currentIndex = 0;
        } else {
          _controller.nextPage(
            duration: widget.transitionDuration,
            curve: Curves.easeInOut,
          );
          _currentIndex++;
        }
      },
    );
  }

  void _pauseAutoScroll() {
    if (_timer.isActive) {
      _timer.cancel();
    }
  }

  void _resumeAutoScroll() {
    Future.delayed(Duration(seconds: widget.autoScrollSeconds), () {
      if (!mounted) return;
      // If timer isn't active, start it again
      if (!_timer.isActive && _data.isNotEmpty) {
        _startAutoScroll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // If for some reason _data is empty, fallback to a single message
    if (_data.isEmpty) {
      return const SizedBox(
        height: 146,
        child: Center(child: Text('No announcements available')),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 146,
          child: GestureDetector(
            onPanStart: (_) => _pauseAutoScroll(),
            onPanEnd: (_) => _resumeAutoScroll(),
            child: PageView.builder(
              controller: _controller,
              itemCount: _data.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final ann = _data[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      ann.imageUrl,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width *
                          widget.viewportFraction,
                      errorBuilder: (ctx, obj, stack) =>
                          const Icon(Icons.error),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // Dots Indicator
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SmoothPageIndicator(
            controller: _controller,
            count: _data.length,
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

  /// Build 4 placeholder announcements with a local asset or fallback image
  List<AnnouncementEntity> _buildPlaceholderAnnouncements() {
    return List.generate(4, (index) {
      return AnnouncementEntity(
        id: 'placeholder-$index',
        title: 'Placeholder ${index + 1}',
        imageUrl: 'assets/images/placeholder.png', // Change as needed
      );
    });
  }
}
