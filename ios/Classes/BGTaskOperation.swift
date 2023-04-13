//
//  RefreshTaskOperation.swift
//  background
//
//  Created by Кирилл Перминов on 11.04.2023.
//

import Foundation
import BackgroundTasks

@available(iOS 13.0, *)
class BGTaskOperation : Operation {
    let task: BGTask
    private var worker: FlutterBackgroundAppWorker?
    
    init(task: BGTask) {
        self.task = task
    }
    
    override func cancel(){}
    
    override func main() {
        let semaphore = DispatchSemaphore(value: 0)
        
        print("I'm the \(task.identifier) task")
        
        DispatchQueue.main.async {
            self.worker = FlutterBackgroundAppWorker(task: self.task)
            
            self.worker?.onCompleted = {
                semaphore.signal()
            }
            
            self.task.expirationHandler = {
                self.worker?.cancel()
            }
            
            self.worker?.run()
        }
        
        semaphore.wait()
    }
    
    
}
