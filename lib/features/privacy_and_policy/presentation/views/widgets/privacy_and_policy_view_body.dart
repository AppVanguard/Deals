import 'package:deals/core/utils/app_images.dart';
import 'package:deals/features/privacy_and_policy/data/privacy_policy_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PrivacyAndPolicyViewBody extends StatelessWidget {
  const PrivacyAndPolicyViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = JsonPrivacyRepository();

    return FutureBuilder<List<String>>(
      future: repo.loadTerms(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final terms = snapshot.data ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            children: [
              SvgPicture.asset(AppImages.assetsImagesPrivacy),
              const SizedBox(height: 24),
              ...terms.map((t) => _BulletItem(text: t)),
            ],
          ),
        );
      },
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  const _BulletItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•', style: TextStyle(fontSize: 20, height: 1.4)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
