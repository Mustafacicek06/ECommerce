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
    
    init(createdAt: String? = nil, name: String?, image: String?, price: String?, description: String? = nil, model: String? = nil, brand: String? = nil, id: String?, isFavorite: Bool? = nil, cardQuantity: Int? = nil) {
        self.createdAt = createdAt
        self.name = name
        self.image = image
        self.price = price
        self.description = description
        self.model = model
        self.brand = brand
        self.id = id
        self.isFavorite = isFavorite
        self.cardQuantity = cardQuantity
    }
}


