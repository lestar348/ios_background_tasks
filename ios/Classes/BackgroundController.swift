//
//  File.swift
//  background
//
//  Created by Кирилл Перминов on 11.04.2023.
//

import Foundation
import BackgroundTasks

@available(iOS 13.0, *)
class BackgroundController{
    
    
    public func registerBGTasks(){
        let defaults = UserDefaults.standard
        let refreshTasksIdentifiers = defaults.object(forKey: "bgRefreshTasksIdentifiers") as? [String] ?? []
        let processingTasksIdentifiers = defaults.object(forKey: "bgProcessingTasksIdentifiers") as? [String] ?? []
        
        for task in refreshTasksIdentifiers + processingTasksIdentifiers{
            BGTaskScheduler.shared.register(
                forTaskWithIdentifier: task,
                using: DispatchQueue.global()
            ) { task in
                self.handleBGTask(task)
            }
        }
    }
    
    
    
    private func handleBGTask(_ task: BGTask) {
        let operationQueue = OperationQueue()
        
        // Schedule a new task.
        scheduleBGTask(task)
        
        // Create an operation that performs the main part of the background task.
        let operation = BGTaskOperation(task: task)
        
        // Provide the background task with an expiration handler that cancels the operation.
        task.expirationHandler = {
            operation.cancel()
        }
        
        // Inform the system that the background task is complete
        // when the operation completes.
        operation.completionBlock = {
            task.setTaskCompleted(success: !operation.isCancelled)
        }
        
        // Start the operation.
        operationQueue.addOperation(operation)
    }
    
    private func scheduleBGTask(_ task: BGTask) {
        switch task {
        case is BGProcessingTask:
            scheduleProcessingTask(task.identifier)
            return
        case is BGAppRefreshTask:
            scheduleRefreshTask(task.identifier)
            return
        default:
            print("Undefined task type")
            return
        }
    }
    
    
    /// Scheduling all background tasks
    /// Get from user defaults tasks identifiers and then schedule there one by one
    func scheduleAllBGTasks() {
        let defaults = UserDefaults.standard
        let refreshTasksIdentifiers = defaults.object(forKey: "bgRefreshTasksIdentifiers") as? [String] ?? []
        let processingTasksIdentifiers = defaults.object(forKey: "bgProcessingTasksIdentifiers") as? [String] ?? []
        
        for taskIdentifier in refreshTasksIdentifiers{
            scheduleRefreshTask(taskIdentifier)
        }
        for taskIdentifier in processingTasksIdentifiers{
            scheduleProcessingTask(taskIdentifier)
        }
    }
    
    private func scheduleRefreshTask(_ identifier: String){
        let request = BGAppRefreshTaskRequest(identifier: identifier)
        // Fetch no earlier than 15 minutes from now.
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Submitted task \(request.identifier) request")
        } catch {
            print("Could not schedule app refresh task \(request.identifier) : \(error)")
        }
    }
    private func scheduleProcessingTask(_ identifier: String){
        let request = BGProcessingTaskRequest(identifier: identifier)
        request.requiresExternalPower = true
        request.requiresNetworkConnectivity = true
        do{
            try BGTaskScheduler.shared.submit(request)
            print("Submitted task \(request.identifier) request")
        } catch {
            print("Could not schedule BG processing task \(request.identifier) : \(error)")
        }
    }
    
}
