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
    let engine = FlutterEngine(name: "BackgroundHandleFlutterEngine")
    
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
            print("No callback handle for background")
            return
        }
        
        let isRunning = engine.run(withEntrypoint: entrypointName, libraryURI: uri, initialRoute: nil, entrypointArgs: [String(callbackHandle!)])
        
        if (isRunning){
            //FlutterBackgroundPlugin.register(engine)
            // MAY BE A REASON OF PROBLEMS
            engine.registrar(forPlugin: "background")
            let binaryMessenger = engine.binaryMessenger
            channel = FlutterMethodChannel(name: "background/task_executing", binaryMessenger: binaryMessenger, codec: FlutterJSONMethodCodec())
            channel?.setMethodCallHandler(handleMethodCall)
        }
    }
    
    public func cancel(){
        DispatchQueue.main.async {
            self.engine.destroyContext()
        }
        
        self.task.setTaskCompleted(success: false)
        self.onCompleted?()
    }
    
    private func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "setBGTaskResult") {
            let result = call.arguments as? Bool ?? false
            self.task.setTaskCompleted(success: result)
            
            DispatchQueue.main.async {
                self.engine.destroyContext()
            }
            
            self.onCompleted?()
            print("Flutter Background Service Completed")
        }
    }
}
