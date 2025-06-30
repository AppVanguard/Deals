# Deals Flutter Application

Deals aggregates coupons, cashback offers and store promotions into a single cross-platform app. It is bundled with a local Flutter SDK, integrates Firebase services and uses Hive for offline storage. The app currently supports English and Arabic.

## Table of Contents
1. [Features](#features)
2. [Technology Stack](#technology-stack)
3. [Architecture](#architecture)
4. [Application Flow](#application-flow)
5. [Directory Overview](#directory-overview)
6. [Module Breakdown](#module-breakdown)
7. [Environment Setup](#environment-setup)
8. [Running & Testing](#running--testing)
9. [Contributing](#contributing)
10. [License](#license)

## Features
- **Authentication** – Email/OTP login plus Google, Facebook and Apple sign in.
- **Home & Search** – Discover stores and coupons with filtering and keyword search.
- **Bookmarks** – Save favourite stores or coupons locally using Hive.
- **Notifications** – Firebase Cloud Messaging delivers deals as local alerts.
- **Profile & Settings** – Manage personal info, change password or delete the account.
- **Help & Legal** – Bundled terms, privacy policy and FAQ for offline reading.
- **Localization** – English and Arabic translations generated with `intl`.
- **Crash Reporting** – Release errors are sent to Sentry for monitoring.

### Additional Details
- **On‑boarding** – Intro slides shown to first time users and persisted with shared preferences.
- **Main Navigation** – Bottom tabs for Home, Stores, Coupons, Notifications and Settings.
- **Stores & Coupons** – Data loaded from a backend API with pagination support.
- **Account Management** – Users can update or delete their account and provide feedback.

## Technology Stack
- **Flutter** 3.32 bundled locally
- **Firebase** – Auth, Cloud Messaging and analytics
- **Hive** – Local database for bookmarks and notifications
- **BLoC/Cubit** – State management
- **go_router** – Declarative routing
- **get_it** – Dependency injection
- **Sentry** – Crash reporting

## Architecture
The project follows a layered design:
1. **Presentation** – Flutter widgets and BLoC/Cubit logic
2. **Domain** – Repositories and entity models
3. **Data/Service** – API clients, data sources and mappers

Routing is provided by `go_router` and dependencies are resolved with `get_it`.

## Application Flow
1. **Splash** – Initializes services
2. **On‑boarding** – Only shown once
3. **Authentication** – Email/OTP or social login
4. **Main View** – Access Stores, Coupons and other tabs
5. **Details** – View coupons or store pages and bookmark them
6. **Notifications** – Offers delivered via FCM and stored for later

## Directory Overview
```
android/    # Android project files
ios/        # iOS project files
linux/      # Linux desktop target
macos/      # macOS desktop target
web/        # Web target
windows/    # Windows desktop target
assets/     # Images, fonts and bundled JSON
flutter/    # Bundled Flutter SDK
lib/        # Application source code
  core/     # Shared services and helpers
  features/ # App modules (auth, home, coupons, ...)
  generated/# Localization output
  l10n/     # Translation files
```
The `test/` folder holds unit tests and `pubspec.yaml` lists all dependencies.

## Module Breakdown
Each feature under `lib/features` is isolated with its own data, domain and presentation layers. Notable modules include:
- **auth** – User sign in, registration and account handling
- **bookmarks** – Manage locally saved coupons and stores
- **coupons** – Browse coupon listings and details
- **faq** – Frequently asked questions screen
- **home** – Landing page with highlighted promotions
- **notifications** – Local persistence of push notifications
- **on_boarding** – Introductory slides shown on first launch
- **personal_data** – Manage saved addresses and personal info
- **privacy_and_policy** – View the privacy policy document
- **search** – Keyword search across coupons and stores
- **settings** – Change password, delete account and other preferences
- **splash** – Initial app launch screen
- **stores** – Store listings and details
- **terms_and_conditions** – Terms of service display

## Environment Setup
### Prerequisites
- Dart SDK 3.6 or later
- The bundled `flutter/` directory or any Flutter SDK >= 3.32
- Firebase project configured for Android, iOS and Web
- Xcode with an iOS 14.0+ toolchain (the project deployment target is 14.0)

### Configuration
Create a `.env` file in the project root with:
```
SENTRY_DSN=<Your Sentry DSN>
Base_Url=<Backend API URL>
```
These values configure crash reporting and API endpoints.

## Running & Testing
Fetch dependencies and run the app using the bundled Flutter SDK:
```bash
./flutter/bin/flutter pub get
./flutter/bin/flutter run
```
Use `-d <device-id>` to select a specific device.

Analyze and run unit tests:
```bash
./flutter/bin/flutter analyze
./flutter/bin/flutter test
```

## Contributing
1. Fork the repository and create a feature branch.
2. Commit your changes with clear messages.
3. Push to your fork and open a pull request.
Please run the analyzer and tests before submitting.

## License
All code in this repository is provided without a license. Contact the repository owner for usage terms.
