//
//  ProductDetailInteractor.swift
//  ECommerce
//
//  Created by Mustafa on 23.12.2024.
//

import Foundation

protocol ProductDetailInteractorProtocol: AnyObject {
    func updateFavoriteStatus(for product: Product)
    func addToCart(product: Product)
}

final class ProductDetailInteractor: ProductDetailInteractorProtocol {
    func updateFavoriteStatus(for product: Product) {
        if let isFavorite = product.isFavorite, isFavorite {
            CoreDataManager.shared.insert(Favorites.self) { favorite in
                favorite.id = product.id
                favorite.name = product.name
                favorite.price = product.price
                favorite.imageURL = product.image
            }
        } else {
            let predicate = NSPredicate(format: "id == %@", product.id ?? "")
            CoreDataManager.shared.delete(Favorites.self, predicate: predicate)
        }
    }

    func addToCart(product: Product) {
        var updatedProduct = product
        updatedProduct.cardQuantity = 1
        CartManager.shared.addItem(updatedProduct)
    }
}
