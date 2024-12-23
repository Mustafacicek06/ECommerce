//
//  FavoriteInteractor.swift
//  ECommerce
//
//  Created by Mustafa Çiçek on 23.12.2024.
//

import Foundation

protocol FavoriteInteractorProtocol: AnyObject {
    func fetchFavorites()
    func deleteFavorite(by id: String)
}

final class FavoriteInteractor: FavoriteInteractorProtocol {
    weak var presenter: FavoriteInteractorOutputProtocol?

    func fetchFavorites() {
        let products = CoreDataManager.shared.fetch(Favorites.self).map {
            FavoriteProductModel(id: $0.id ?? "", name: $0.name ?? "", price: $0.price ?? "", imageURL: $0.imageURL)
        }
        presenter?.didFetchFavorites(products)
    }

    func deleteFavorite(by id: String) {
        let predicate = NSPredicate(format: "id == %@", id)
        CoreDataManager.shared.delete(Favorites.self, predicate: predicate)
        fetchFavorites() // Güncel listeyi getir
    }
}
