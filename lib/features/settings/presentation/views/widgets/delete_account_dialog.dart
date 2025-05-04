import 'package:deals/core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:deals/generated/l10n.dart';
import 'package:deals/core/utils/app_colors.dart';
import 'package:flutter_svg/svg.dart';

/// A rounded confirmation dialog for “Delete Account”.
/// - [onConfirm] is called when the user taps “Delete”
/// - [onCancel] or tapping outside simply closes the dialog.
class DeleteAccountDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteAccountDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: 298,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: ShapeDecoration(
          color: AppColors.background,
          shadows: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 6,
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(AppImages.assetsImagesDelete),

            const SizedBox(height: 16),

            // Title & message
            Text(
              s.deleteAccount,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D241F),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              s.deleteAccountWarning,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF1D241F),
                height: 1.5,
              ),
            ),

            const SizedBox(height: 16),

            // Actions
            Row(
              children: [
                // Cancel
                Expanded(
                  child: TextButton(
                    onPressed: Navigator.of(context).pop,
                    child: Text(
                      s.cancel,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D241F),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Delete
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      s.delete,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
