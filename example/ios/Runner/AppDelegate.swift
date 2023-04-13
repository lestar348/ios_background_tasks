import UIKit
import background
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let bgRefreshTasksIdentifiers = ["com.vergo.iosBackground.refresh.testRefresh"]
    let bgProcessingTasksIdentifiers = ["com.vergo.iosBackground.ProcessingTask.testProcessing"]
    
    BackgroundPlugin().saveIdentifires(bgProcessingTasksIdentifiers: bgProcessingTasksIdentifiers, bgRefreshTasksIdentifiers: bgRefreshTasksIdentifiers)
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
