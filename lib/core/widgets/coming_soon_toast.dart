import 'package:flutter/material.dart';
import 'package:deals/core/utils/app_colors.dart';

/// Call this anywhere to show a 2-second “Coming soon” toast.
///
/// ```dart
/// showComingSoonToast(context, 'Earnings');
/// ```
void showComingSoonToast(BuildContext context, String featureName) {
  final overlay = Overlay.of(context);

  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => Positioned(
      bottom: 100,
      left: 40,
      right: 40,
      child: _AnimatedToast(entry: entry, featureName: featureName),
    ),
  );

  overlay.insert(entry);
}

// ──────────────────────────────────────────────────────────────────────────────
// Internal animated widget
// ──────────────────────────────────────────────────────────────────────────────
class _AnimatedToast extends StatefulWidget {
  final OverlayEntry entry;
  final String featureName;

  const _AnimatedToast({
    required this.entry,
    required this.featureName,
  });

  @override
  State<_AnimatedToast> createState() => _AnimatedToastState();
}

class _AnimatedToastState extends State<_AnimatedToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300));
  late final Animation<double> _fade =
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

  @override
  void initState() {
    super.initState();

    // Fade-in
    _controller.forward();

    // Auto-dismiss after 2 s
    Future.delayed(const Duration(seconds: 2), () {
      _controller.reverse().then((_) => widget.entry.remove());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Center(
            child: Text(
              '${widget.featureName}  —  Coming Soon',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
