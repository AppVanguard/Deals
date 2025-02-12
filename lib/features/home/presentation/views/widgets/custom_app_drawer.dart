import 'package:flutter/material.dart';
import 'package:in_pocket/core/widgets/app_version_text.dart';
import 'package:in_pocket/generated/l10n.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final s = S.of(context); // For easier referencing

    return Align(
      alignment: Alignment.topLeft,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        child: Container(
          height: deviceHeight * 0.70,
          width: deviceWidth * 0.80,
          color: Colors.white,
          child: Drawer(
            child: Column(
              children: [
                // Header (Green background)
                Container(
                  color: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 16,
                  ),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mahmoud Gabal',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'mgabal903@gmail.com',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                    ],
                  ),
                ),

                // Body with ListTiles
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.trending_up),
                          title: Text(s.earnings),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(s.personalData),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(Icons.description),
                          title: Text(s.termsAndConditions),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(Icons.privacy_tip),
                          title: Text(s.privacyPolicy),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(Icons.settings),
                          title: Text(s.settings),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(Icons.help_outline),
                          title: Text(s.help),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(Icons.mail_outline),
                          title: Text(s.contactUs),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),

                // Footer
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.red),
                  title: Text(
                    s.logOut,
                    style: const TextStyle(color: Colors.red),
                  ),
                  onTap: () {},
                ),
                const SizedBox(height: 10),
                Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppVersionText()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
