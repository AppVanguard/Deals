
import 'package:flutter/material.dart';
import 'package:deals/generated/l10n.dart';

class SettingsViewBody extends StatelessWidget {
  final bool pushEnabled;
  final bool isLoading;
  final ValueChanged<bool> onTogglePush;

  const SettingsViewBody({
    super.key,
    required this.pushEnabled,
    required this.isLoading,
    required this.onTogglePush,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(16),
          children: [
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.lock_outline),
                title: Text(s.changePassword),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {}, // no-op for now
              ),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: Text(s.deleteAccount,
                    style: const TextStyle(color: Colors.red)),
                trailing: const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.red),
                onTap: () {}, // no-op for now
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
