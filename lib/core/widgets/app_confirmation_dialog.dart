import 'package:flutter/material.dart';

/// Generic material confirmation dialog.
///
/// Returns:
/// * `true`  → user confirmed
/// * `false` → user cancelled
/// * `null`  → user tapped outside / pressed back (also treated as cancel)
class AppConfirmationDialog extends StatelessWidget {
  const AppConfirmationDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.cancelLabel,
    required this.confirmLabel,
    required this.confirmColor,
  });

  final Widget icon;
  final String title;
  final String message;
  final String cancelLabel;
  final String confirmLabel;
  final Color confirmColor;

  @override
  Widget build(BuildContext context) {
    // NO Center wrapper → taps outside reach the barrier
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: _DialogCard(
        icon: icon,
        title: title,
        message: message,
        cancelLabel: cancelLabel,
        confirmLabel: confirmLabel,
        confirmColor: confirmColor,
      ),
    );
  }
}

/* ─────────────────── internal UI ─────────────────── */

class _DialogCard extends StatelessWidget {
  const _DialogCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.cancelLabel,
    required this.confirmLabel,
    required this.confirmColor,
  });

  final Widget icon;
  final String title;
  final String message;
  final String cancelLabel;
  final String confirmLabel;
  final Color confirmColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 298,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF1D241F),
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF1D241F),
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _PlainActionButton(
                  label: cancelLabel,
                  onTap: () => Navigator.of(context).pop(false),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ColoredActionButton(
                  label: confirmLabel,
                  color: confirmColor,
                  onTap: () => Navigator.of(context).pop(true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlainActionButton extends StatelessWidget {
  const _PlainActionButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}

class _ColoredActionButton extends StatelessWidget {
  const _ColoredActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}
