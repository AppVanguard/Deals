import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:in_pocket/features/home/domain/entities/announcement_entity.dart';

class SalesCarousel extends StatefulWidget {
  final List<AnnouncementEntity> announcements;
  final bool isLoading;

  const SalesCarousel({
    Key? key,
    required this.announcements,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<SalesCarousel> createState() => _SalesCarouselState();
}

class _SalesCarouselState extends State<SalesCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.8);
  Timer? _timer;
  int _currentIndex = 0;

  // For placeholder mode
  PageController? _placeholderController;
  Timer? _placeholderTimer;
  int _placeholderIndex = 0;
  bool _isPlaceholderMode = false;

  @override
  void initState() {
    super.initState();
    // if no announcements but isLoading => placeholder mode
    if (widget.announcements.isEmpty && widget.isLoading) {
      _isPlaceholderMode = true;
      _initPlaceholderAutoScroll();
    } else if (widget.announcements.isNotEmpty) {
      _startAutoScroll();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();

    _placeholderTimer?.cancel();
    _placeholderController?.dispose();
    super.dispose();
  }

  // Real data auto-scroll
  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      final lastIndex = widget.announcements.length - 1;
      if (_currentIndex == lastIndex) {
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

  void _pauseAutoScroll() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
  }

  void _resumeAutoScroll() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      if (!(_timer?.isActive ?? false) && widget.announcements.isNotEmpty) {
        _startAutoScroll();
      }
    });
  }

  // Placeholder mode
  void _initPlaceholderAutoScroll() {
    _placeholderController = PageController(viewportFraction: 0.8);
    _startPlaceholderAutoScroll();
  }

  void _startPlaceholderAutoScroll() {
    _placeholderTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_placeholderIndex == 3) {
        _placeholderController?.jumpToPage(0);
        _placeholderIndex = 0;
      } else {
        _placeholderController?.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _placeholderIndex++;
      }
    });
  }

  void _pausePlaceholderAutoScroll() {
    if (_placeholderTimer?.isActive ?? false) {
      _placeholderTimer?.cancel();
    }
  }

  void _resumePlaceholderAutoScroll() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      if (!(_placeholderTimer?.isActive ?? false)) {
        _startPlaceholderAutoScroll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final announcements = widget.announcements;

    if (_isPlaceholderMode) {
      return _buildPlaceholderCarousel();
    }
    if (announcements.isEmpty && !widget.isLoading) {
      return const SizedBox(
        height: 146,
        child: Center(child: Text('No announcements found')),
      );
    }
    if (announcements.isNotEmpty) {
      return _buildRealCarousel(announcements);
    }
    // fallback
    return const SizedBox(height: 146);
  }

  Widget _buildRealCarousel(List<AnnouncementEntity> announcements) {
    return Column(
      children: [
        SizedBox(
          height: 146,
          child: GestureDetector(
            onPanStart: (_) => _pauseAutoScroll(),
            onPanEnd: (_) => _resumeAutoScroll(),
            child: PageView.builder(
              controller: _controller,
              itemCount: announcements.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                final ann = announcements[index];
                return Skeletonizer(
                  enabled: widget.isLoading,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        ann.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, obj, st) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SmoothPageIndicator(
            controller: _controller,
            count: announcements.length,
            effect: const WormEffect(
              dotWidth: 8.0,
              dotHeight: 8.0,
              activeDotColor: AppColors.primary,
              dotColor: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 146,
          child: GestureDetector(
            onPanStart: (_) => _pausePlaceholderAutoScroll(),
            onPanEnd: (_) => _resumePlaceholderAutoScroll(),
            child: PageView.builder(
              controller: _placeholderController,
              itemCount: 4,
              onPageChanged: (index) =>
                  setState(() => _placeholderIndex = index),
              itemBuilder: (context, index) {
                return Skeletonizer(
                  enabled: true,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const SizedBox(
                      width: double.infinity,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        SmoothPageIndicator(
          controller: _placeholderController ?? PageController(),
          count: 4,
          effect: const WormEffect(
            dotWidth: 8.0,
            dotHeight: 8.0,
            activeDotColor: AppColors.primary,
            dotColor: Colors.grey,
          ),
        ),
      ],
    );
  }
}
