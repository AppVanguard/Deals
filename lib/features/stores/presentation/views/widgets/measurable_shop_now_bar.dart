import 'package:flutter/material.dart';
import 'shop_now_bar.dart';

/// Wraps ShopNowBar and reports its rendered height via [onHeightChanged].
class MeasurableShopNowBar extends StatefulWidget {
  const MeasurableShopNowBar({
    super.key,
    required this.onPressed,
    required this.onHeightChanged,
    this.discountValue,
  });

  final ValueChanged<double> onHeightChanged;
  final VoidCallback onPressed;
  final String? discountValue;

  @override
  State<MeasurableShopNowBar> createState() => _MeasurableShopNowBarState();
}

class _MeasurableShopNowBarState extends State<MeasurableShopNowBar> {
  final GlobalKey _barKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // We can't measure right away; wait until after the layout is done
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeight());
  }

  @override
  void didUpdateWidget(covariant MeasurableShopNowBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the widget updates (e.g. content changes), re-measure
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeight());
  }

  void _measureHeight() {
    if (!mounted) return;
    final renderBox = _barKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final height = renderBox.size.height;
      widget.onHeightChanged(height);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _barKey, // Attach the GlobalKey to measure the final size
      child: ShopNowBar(
        onPressed: widget.onPressed,
        discountValue: widget.discountValue,
      ),
    );
  }
}
