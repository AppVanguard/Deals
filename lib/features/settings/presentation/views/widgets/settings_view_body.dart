import 'package:deals/core/utils/app_colors.dart';
import 'package:deals/core/utils/app_images.dart';
import 'package:deals/features/settings/presentation/views/change_password_view.dart';
import 'package:deals/features/settings/presentation/views/delete_account_view.dart';
import 'package:flutter/material.dart';
import 'package:deals/core/widgets/error_message_card.dart';
import 'package:deals/generated/l10n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SettingsViewBody extends StatelessWidget {
  final bool pushEnabled;
  final bool isLoading;
  final ValueChanged<bool> onTogglePush;
  final String? errorMessage;

  const SettingsViewBody({
    super.key,
    required this.pushEnabled,
    required this.isLoading,
    required this.onTogglePush,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (errorMessage != null)
              ErrorMessageCard(
                title: errorMessage!,
                description: 'Failed to update settings.',
              ),
            // Push toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(s.pushNotifications, style: const TextStyle(fontSize: 16)),
                Switch(
                  value: pushEnabled,
                  onChanged: onTogglePush,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),

            // Buttons placeholders
            const SizedBox(height: 24),
            Card(
              color: AppColors.background,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.lock_outline),
                title: Text(s.changePassword),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  context.pushNamed(ChangePasswordView.routeName);
                }, // no-op for now
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: AppColors.background,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                leading: SvgPicture.asset(AppImages.assetsImagesDelete),
                title: Text(s.deleteAccount,
                    style: const TextStyle(color: Colors.red)),
                trailing: const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.red),
                onTap: () {
                  context.pushNamed(DeleteAccountView.routeName);
                }, // no-op for now
              ),
            ),
          ],
        ),
        if (isLoading)
          Container(
            color: Colors.black26,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
