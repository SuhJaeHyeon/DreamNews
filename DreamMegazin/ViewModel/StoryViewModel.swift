//
//  StoryViewModel.swift
//  DreamMegazin
//
//  Created by martin on 6/26/24.
//

import Foundation
import Combine

class SpoonViewModel: ObservableObject {
    @Published var products: [StoryProduct] = []

    init() {
        loadProducts()
    }

    private func loadProducts() {
        products = [
            StoryProduct(base: 747, bonus: 403, price: 299000, isBest: true),
            StoryProduct(base: 622, bonus: 285, price: 249000, isBest: false),
            StoryProduct(base: 422, bonus: 158, price: 169000, isBest: false),
            StoryProduct(base: 199, bonus: 53, price: 79900, isBest: false)
        ]
    }
}
