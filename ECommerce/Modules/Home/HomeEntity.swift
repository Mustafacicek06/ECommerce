//
//  HomeEntity.swift
//  ECommerce
//
//  Created by Mustafa on 21.12.2024.
//

struct Products: Decodable {
    let products: [Product]
}

struct Product: Decodable {
    let createdAt: String?
    let name: String?
    let image: String?
    let price: String?
    let description: String?
    let model: String?
    let brand: String?
    let id: String?
    let isFavorite: Bool?
    var cardQuantity: Int?
}


