import UIKit
import Flutter
import Firebase
import FirebaseMessaging

@main
@objc
class AppDelegate: FlutterAppDelegate, MessagingDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // 1. Configure Firebase
    FirebaseApp.configure()
    NSLog("AppDelegate: Firebase configured")

    // 2. Set up notification delegates
    UNUserNotificationCenter.current().delegate = self
    Messaging.messaging().delegate = self

    // 3. Register Flutter plugins & remote notifications
    GeneratedPluginRegistrant.register(with: self)
    application.registerForRemoteNotifications()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // MARK: - APNs token → Firebase
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
    NSLog("AppDelegate: APNS token registered")
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  // MARK: - FCM registration token callback
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    if let token = fcmToken {
      NSLog("AppDelegate: FCM registration token: \(token)")
      // TODO: send token to your backend if needed
    }
  }

  // MARK: - Foreground notification display (classic method)
  // This is the old signature—no async—so it works on iOS 13+
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    NSLog("AppDelegate: notification willPresent")

    // You can customize these options however you like:
    var opts: UNNotificationPresentationOptions = [.badge, .sound]
    if #available(iOS 14.0, *) {
      opts.formUnion([.banner, .list])
    } else {
      opts.formUnion([.alert])
    }

    completionHandler(opts)
  }
}
