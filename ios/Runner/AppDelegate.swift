//import Flutter
//import UIKit
//
//@main
//@objc class AppDelegate: FlutterAppDelegate {
//  override func application(
//    _ application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//  ) -> Bool {
//    GeneratedPluginRegistrant.register(with: self)
//    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//  }
//}


import Flutter
import UIKit
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let channelName = "lockscreen_channel"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Register Flutter plugins
    GeneratedPluginRegistrant.register(with: self)

    // Access root Flutter controller to create the method channel
    if let controller = window?.rootViewController as? FlutterViewController {
      let methodChannel = FlutterMethodChannel(
        name: channelName,
        binaryMessenger: controller.binaryMessenger
      )

      methodChannel.setMethodCallHandler { [weak self] call, result in
        if call.method == "updateCounter" {
          guard
            let args = call.arguments as? [String: Any],
            let counter = args["counter"] as? Int
          else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing 'counter' value", details: nil))
            return
          }

          // Save to App Group-shared UserDefaults
          self?.saveCounterToSharedDefaults(counter)
          result(nil)
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func saveCounterToSharedDefaults(_ counter: Int) {
    let appGroupID = "group.com.gaztec.lockwidget"
    if let defaults = UserDefaults(suiteName: appGroupID) {
      defaults.set(counter, forKey: "counter")
      defaults.synchronize() // optional, ensures immediate write for widget access
        WidgetCenter.shared.reloadAllTimelines()
    }
  }
}
