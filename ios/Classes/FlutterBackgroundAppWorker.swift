//
//  FlutterBackgroundAppWorker.swift
//  background
//
//  Created by Кирилл Перминов on 12.04.2023.
//

import Foundation
import Flutter

import BackgroundTasks

typealias VoidInputVoidReturnBlock = () -> Void

@available(iOS 13, *)
class FlutterBackgroundAppWorker{
    let entrypointName = "bgTaskEntrypoint"
    let uri = "package:background/background.dart"
    let engine = FlutterEngine(name: "BackgroundFlutterEngine")
    
    var onCompleted: VoidInputVoidReturnBlock?
    var task: BGTask
    var channel: FlutterMethodChannel?
    
    init(task: BGTask){
        self.task = task
    }
    
    
    
    public func run() {
        let defaults = UserDefaults.standard
        let callbackHandle = defaults.object(forKey: task.identifier) as? Int
        if (callbackHandle == nil){
            print("No callback handle for task \(task.identifier)")
            self.compliteTask(success: false)
            return
        }
        
        let isRunning = engine.run(withEntrypoint: entrypointName, libraryURI: uri, initialRoute: nil, entrypointArgs: [String(callbackHandle!)])
        
        if (isRunning){
            //FlutterBackgroundPlugin.register(engine)
            // MAY BE A REASON OF PROBLEMS
            //GeneratedPluginRegistrant.register(with: self)
            engine.registrar(forPlugin: "background")
            
            let binaryMessenger = engine.binaryMessenger
            channel = FlutterMethodChannel(name: "background/task_executing", binaryMessenger: binaryMessenger, codec: FlutterJSONMethodCodec())
            channel?.setMethodCallHandler(handleMethodCall)
        }
    }
    
    public func cancel(){
        let defaults = UserDefaults.standard
        let cancelHandleID = defaults.object(forKey: task.identifier+Constants.cancelSuffix) as? Int
        if(cancelHandleID != nil){
            channel?.invokeMethod("cancel_task", arguments: [String(cancelHandleID!)])
        } else{
            self.compliteTask(success: false)
        }
        
    }
    
    private func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "setBGTaskResult":
            let result = call.arguments as? Bool ?? false
            self.compliteTask(success: result)
            break;
        case "setCanelTaskResult":
            let result = call.arguments as? Bool ?? false
            self.compliteTask(success: result)
            break;
        default:
            break;
        }
        
    }
    
    private func compliteTask(success: Bool){
        DispatchQueue.main.async {
            self.engine.destroyContext()
        }
        
        // Inform the system that the background task is complete
        // when the operation completes.
        self.task.setTaskCompleted(success: success)
        self.onCompleted?()
        print("Task \(task.identifier) Completed, success: \(success)")
    }
    
}
