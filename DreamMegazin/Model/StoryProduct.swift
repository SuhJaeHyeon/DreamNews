//
//  StoryProduct.swift
//  DreamMegazin
//
//  Created by martin on 6/26/24.
//

import Foundation
struct StoryProduct: Identifiable {
    let id = UUID()
    let base: Int
    let bonus: Int
    let price: Int
    let isBest: Bool
}
