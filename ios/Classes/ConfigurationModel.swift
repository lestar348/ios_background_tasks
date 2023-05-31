//
//  ConfigurationModel.swift
//  background
//
//  Created by Кирилл Перминов on 12.04.2023.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let configuration = try? JSONDecoder().decode(Configuration.self, from: jsonData)

import Foundation

// MARK: - Configuration
class Configuration: Codable {
    let refreshTasks, processingTasks: [Task]

    enum CodingKeys: String, CodingKey {
        case refreshTasks = "refresh_tasks"
        case processingTasks = "processing_tasks"
    }

    init(refreshTasks: [Task], processingTasks: [Task]) {
        self.refreshTasks = refreshTasks
        self.processingTasks = processingTasks
    }
}

// MARK: - Task
class Task: Codable {
    let identifier: String
    let rawCallbackHandleID: Int
    let rawCancelID: Int?

    enum CodingKeys: String, CodingKey {
        case identifier
        case rawCallbackHandleID = "raw_callback_handle_ID"
        case rawCancelID = "raw_cancel_ID"
    }

    init(identifier: String, rawCallbackHandleID: Int, rawCancelID: Int?) {
        self.identifier = identifier
        self.rawCallbackHandleID = rawCallbackHandleID
        self.rawCancelID = rawCancelID
    }
}


