# Deals Flutter Application

Deals is a cross-platform Flutter application providing coupon and cashback offers from numerous stores. It integrates Firebase for authentication and push notifications, utilizes local caching, and supports English and Arabic. This repository includes the Flutter SDK, so no external installation is required.

## Features

- **User Authentication** – Email & password signup with OTP verification, OAuth via Google, Facebook and Apple.
- **Home & Search** – Browse stores and coupons, filter by categories and keywords.
- **Bookmarks** – Save favourite coupons or stores locally with Hive.
- **Push Notifications** – Receive offers using Firebase Cloud Messaging and display them via local notifications.
- **Profile & Settings** – Manage personal data, change password, delete account and configure notification permissions.
- **Legal & Help** – Terms & conditions, privacy policy and FAQ content from bundled JSON files.
- **Localization** – English and Arabic translations powered by the `intl` package.
- **Crash Reporting** – Integrated with Sentry for capturing errors in release builds.

## Getting Started

### Prerequisites

- Dart SDK >= 3.6
- No separate Flutter installation is needed. Use the bundled `flutter` directory or any compatible Flutter 3.32+ SDK.
- A Firebase project with Android, iOS and Web configurations.

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone <repo-url>
   cd Deals
   ```
2. **Configure environment variables**
   Create a `.env` file in the project root. Sample keys:
   ```text
   SENTRY_DSN=<Your Sentry DSN>
   Base_Url=<Backend base URL>
   ```
3. **Fetch dependencies**
   ```bash
   ./flutter/bin/flutter pub get
   ```
4. **Run the application**
   ```bash
   ./flutter/bin/flutter run
   ```
   By default it runs on the connected device or emulator. Use `-d` to specify a device id.
5. **Analyze and test**
   ```bash
   ./flutter/bin/flutter analyze
   ./flutter/bin/flutter test
   ```

## Project Structure

```
lib/
  core/       # Reusable services, models and utilities
  features/   # Individual modules such as auth, home, coupons, search, ...
  generated/  # Generated localization code
  l10n/       # .arb translation files
```
Other platform folders (`android`, `ios`, `linux`, `macos`, `web`, `windows`) are the standard Flutter targets. The `assets/` directory contains images, fonts and JSON files used across the app.

### iOS Optimization

To reduce startup times on iOS, the `Podfile` links CocoaPods frameworks statically.

## Contributing

1. Fork the repository and create your feature branch.
2. Commit your changes with clear messages.
3. Push to your fork and open a pull request.

Please make sure to run the analysis and tests before submitting.

## License

All code in this repository is provided without a license. Contact the repository owner for usage terms.
