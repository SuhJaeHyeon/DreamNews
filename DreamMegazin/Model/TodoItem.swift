//
//  TodoItem.swift
//  DreamMegazin
//
//  Created by martin on 6/13/24.
//

import Foundation
struct TodoItem: Identifiable {
    let id: UUID
    var title: String
    var isCompleted: Bool
}
