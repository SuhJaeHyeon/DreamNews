//
//  TodoItem.swift
//  DreamMegazin
//
//  Created by martin on 6/13/24.
//

import Foundation
struct TodoItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var eventIdentifier: String?
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool, eventIdentifier: String? = nil) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.eventIdentifier = eventIdentifier
    }
}
