import Flutter
import UIKit

@available(iOS 13.0, *)
public class BackgroundPlugin: FlutterPluginAppLifeCycleDelegate, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "background", binaryMessenger: registrar.messenger())
        let instance = BackgroundPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    /// Notify app about switching to background mode
    /// We have 5 seconds to perform any task and schedule background tasks
    public func applicationDidEnterBackground(_ application: UIApplication) {
        BackgroundController().scheduleAllBGTasks()
    }
    
    public func saveIdentifires(bgProcessingTasksIdentifiers: [String], bgRefreshTasksIdentifiers: [String]){
        let defaults = UserDefaults.standard
        // Save all identifiers of refresh tasks
        defaults.set(bgProcessingTasksIdentifiers, forKey: Constants.processingTasksKey)
        // Save all identifiers of refresh tasks
        defaults.set(bgRefreshTasksIdentifiers, forKey: Constants.refreshTasksKey)
        
        BackgroundController().registerBGTasks()
    }
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method{
        case "configurate":
            guard let configuration = try? JSONDecoder().decode(Configuration.self, from: Data((call.arguments as! String).utf8) ) else{
                result(false)
                break
            }
            
            result(configurate(configuration: configuration))
            
            // Line for debug, delete after all func will bet tested
            BackgroundController().scheduleAllBGTasks()
            break
        default:
            break
            
        }
    }
    
    /// Save in  UserDefaults.standard tasks identifiers and raw Callback Handle IDs
    /// Register BG tasks in BGTaskScheduler
    private func configurate(configuration: Configuration)->Bool{
        let defaults = UserDefaults.standard
        
        // Save raw Callback Handle IDs for refresh tasks
        for refreshTask in configuration.refreshTasks{
            defaults.set(refreshTask.rawCallbackHandleID, forKey: refreshTask.identifier)
            if(refreshTask.rawCancelID != nil){
                defaults.set(refreshTask.rawCancelID, forKey: refreshTask.identifier + Constants.cancelSuffix)
            }
            
        }
        
        // Save raw Callback Handle IDs for processing tasks
        for processingTask in configuration.processingTasks{
            defaults.set(processingTask.rawCallbackHandleID, forKey: processingTask.identifier)
            
            if(processingTask.rawCancelID != nil){
                defaults.set(processingTask.rawCancelID, forKey: processingTask.identifier + Constants.cancelSuffix)
            }
        }
        
        return true
        
    }
}
