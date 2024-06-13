//
//  News.swift
//  DreamMegazin
//
//  Created by martin on 6/13/24.
//

import Foundation
struct News: Codable , Identifiable {
    let id: UUID
    var title: String
    var date: Date
    var content: String
    var isCompleted: Bool
}
