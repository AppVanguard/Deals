import 'package:flutter/material.dart';
import 'package:deals/generated/l10n.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Small widget that asynchronously retrieves and displays the app version.
///
/// It queries [PackageInfo] on init and shows a "Loading..." placeholder until
/// the version is available. Useful in settings or about pages.

/// Displays "vX.X.X+build" when the information is ready.

class AppVersionText extends StatefulWidget {
  const AppVersionText({super.key});

  @override
  State<AppVersionText> createState() => _AppVersionTextState();
}

class _AppVersionTextState extends State<AppVersionText> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version; // e.g. "1.0.0"
    final buildNumber = packageInfo.buildNumber; // e.g. "42"

    setState(() {
      _version = '$version+$buildNumber';
      // Or just use `version` if you don’t want the build number
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _version.isEmpty ? 'Loading...' : '${S.of(context).appVersion} $_version',
      style: const TextStyle(color: Colors.grey),
    );
  }
}
