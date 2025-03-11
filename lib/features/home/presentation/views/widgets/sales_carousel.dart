import 'dart:async';
import 'package:flutter/material.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:deals/core/entities/announcement_entity.dart';

class SalesCarousel extends StatefulWidget {
  final List<AnnouncementEntity> announcements;
  final bool isLoading;

  const SalesCarousel({
    super.key,
    required this.announcements,
    required this.isLoading,
  });

  @override
  State<SalesCarousel> createState() => _SalesCarouselState();
}

class _SalesCarouselState extends State<SalesCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.8);
  Timer? _timer;
  int _currentIndex = 0;

  // Compute the display list: if announcements is empty and loading is true,
  // generate 4 placeholder announcements; otherwise, use the real announcements.
  List<AnnouncementEntity> get displayAnnouncements {
    if (widget.announcements.isEmpty || widget.isLoading) {
      return List.generate(
          4,
          (_) => const AnnouncementEntity(
                id: '',
                imageUrl: '',
                title: '',
                deletedAt: '',
                description: '',
                isActive: false,
              ));
    }
    return widget.announcements;
  }

  int get itemCount => displayAnnouncements.length;

  @override
  void initState() {
    super.initState();
    // Start auto-scroll if we have more than one item.
    if (itemCount > 1) {
      _startAutoScroll();
    }
  }

  @override
  void didUpdateWidget(covariant SalesCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the loading state or list length changes, reset auto-scroll.
    if (oldWidget.isLoading != widget.isLoading ||
        oldWidget.announcements.length != widget.announcements.length) {
      _timer?.cancel();
      _currentIndex = 0;
      if (itemCount > 1) {
        _startAutoScroll();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      final lastIndex = itemCount - 1;
      if (_currentIndex >= lastIndex) {
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
      if (itemCount > 1 && (_timer == null || !_timer!.isActive)) {
        _startAutoScroll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 146,
          child: GestureDetector(
            onPanStart: (_) => _pauseAutoScroll(),
            onPanEnd: (_) => _resumeAutoScroll(),
            child: PageView.builder(
              controller: _controller,
              itemCount: itemCount,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                final ann = displayAnnouncements[index];
                return Skeletonizer(
                  enabled: widget.isLoading,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        ann.imageUrl ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, obj, st) => Image.asset(
                            AppImages.assetsImagesTest3,
                            fit: BoxFit.fill),
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
            count: itemCount,
            effect: const WormEffect(
              dotWidth: 8.0,
              dotHeight: 8.0,
              activeDotColor: AppColors.primary,
              dotColor: Color.fromARGB(255, 39, 35, 35),
            ),
          ),
        ),
      ],
    );
  }
}
