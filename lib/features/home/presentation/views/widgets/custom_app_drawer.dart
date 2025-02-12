import 'package:flutter/material.dart';
import 'package:in_pocket/core/utils/app_colors.dart';
import 'package:in_pocket/core/widgets/app_version_text.dart';
import 'package:in_pocket/generated/l10n.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context); // Localized strings
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        // Limit the drawer to 70% height and 80% width
        height: screenHeight * 0.80,
        width: screenWidth * 0.80,
        child: Drawer(
          // Let Drawer handle its shape & background
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          backgroundColor: Colors.white,
          child: Column(
            // Outer column that holds header, body (expanded), and footer
            children: [
              // 1) Header (Green background)
              Container(
                color: AppColors.darkPrimary,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 16,
                ),
                child: Column(
                  // Use spacing here to avoid extra SizedBox
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mahmoud Gabal',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white),
                    ),
                    Text(
                      'mgabal903@gmail.com',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              // 2) Body: scrollable list of ListTiles
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    // If you want space between each ListTile, set a spacing value here:
                    spacing: 10,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.attach_money),
                        title: Text(s.earnings),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(s.personalData),
                        onTap: () {},
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(),
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

              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title: Text(
                  s.logOut,
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () {},
              ),
              // Extra spacing before the version text
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: AppVersionText(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
