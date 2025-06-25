# Deals Flutter Application

Deals is a full‑stack Flutter application that aggregates coupons, cashback deals
and store offers. It runs on Android, iOS, web and desktop platforms. The app
ships with a bundled Flutter SDK so no external installation is required.
It integrates Firebase for authentication and push notifications, uses Hive for
local caching and supports both English and Arabic.

## Architecture Overview

The project follows a layered approach:

1. **Presentation** – Flutter widgets and BLoC/Cubit state management.
2. **Domain** – Repositories and mapping logic between data models and
   entities.
3. **Data/Service** – HTTP/Firebase clients, local storage and API models.

Routing is handled with `go_router` and the app uses a dependency injection
container via `get_it`.

## Application Flow

1. User lands on the **Splash** screen which initializes services.
2. First‑time users go through the **On‑boarding** screens.
3. Authentication is required for most features – users can register or sign in.
4. After login, the **Main view** provides tabs for Home, Stores, Coupons,
   Notifications and Settings.
5. Selecting a coupon or store opens a detailed view. Items can be bookmarked for
   quick access.
6. Push notifications from FCM trigger local alerts and are stored for later
   viewing.

## Features

- **User Authentication** – Email/password signup with OTP verification plus
  social login (Google, Facebook, Apple). Password reset and account update are
  fully supported.
- **Home & Search** – Discover stores and coupons, search by keyword or
  category and view featured promotions.
- **Bookmarks** – Save favourite coupons or stores locally using Hive for quick
  offline access.
- **Notifications** – Firebase Cloud Messaging delivers offers which are shown as
  local notifications even when the app is in the background.
- **Profile & Settings** – Edit personal information, change password, delete the
  account and manage notification permissions.
- **Help & Legal** – Terms of service, privacy policy and FAQ are bundled as
  local JSON files.
- **Localization** – English and Arabic translations generated with `intl`.
- **Crash Reporting** – Sentry captures uncaught errors in release builds.

### Feature Breakdown

  - **On‑boarding** – Intro slides the first time the app is opened. Completion is stored using shared preferences.
  - **Main view** – Bottom navigation with Home, Stores, Coupons, Notifications and Settings tabs.
  - **Stores & Coupons** – Data is fetched from a backend API. Pagination and filtering are supported.
  - **Bookmarks** – Stored using Hive and synced per user when logged in.
  - **Notifications** – Messages are persisted in a Hive box so users can browse them later.
  - **Personal Data** – Users can view and edit their saved details and address information.
  - **Account Management** – Change password or delete the account with optional feedback on the reason.

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

Variable | Purpose
--- | ---
`SENTRY_DSN` | DSN URL for Sentry crash reporting
`Base_Url` | Backend API base URL
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
  core/       # shared services, API clients, utilities
  features/   # isolated modules such as auth, home, coupons, etc.
  generated/  # localization output
  l10n/       # translation .arb files
```
Other platform folders (`android`, `ios`, `linux`, `macos`, `web`, `windows`) are
the standard Flutter targets. The `flutter/` directory contains a pre‑bundled
SDK used for development. The `assets/` folder holds images, fonts and local
JSON files used across the app.

### iOS Optimization

To reduce startup times on iOS, the `Podfile` links CocoaPods frameworks statically.

## Contributing

1. Fork the repository and create your feature branch.
2. Commit your changes with clear messages.
3. Push to your fork and open a pull request.

Please make sure to run the analysis and tests before submitting.

## License

All code in this repository is provided without a license. Contact the repository owner for usage terms.
