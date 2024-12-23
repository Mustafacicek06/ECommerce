//
//  FavoritePresenter.swift
//  ECommerce
//
//  Created by Mustafa Çiçek on 23.12.2024.
//

import Foundation

protocol FavoritePresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectDelete(for id: String)
}

protocol FavoriteInteractorOutputProtocol: AnyObject {
    func didFetchFavorites(_ products: [FavoriteProductModel])
    func didFailFetchingFavorites(_ error: String)
}

final class FavoritePresenter: FavoritePresenterProtocol {
    weak var view: FavoriteViewProtocol?
    var interactor: FavoriteInteractorProtocol?
    var router: FavoriteRouterProtocol?

    func viewDidLoad() {
        interactor?.fetchFavorites()
    }

    func didSelectDelete(for id: String) {
        interactor?.deleteFavorite(by: id)
    }
}

extension FavoritePresenter: FavoriteInteractorOutputProtocol {
    func didFetchFavorites(_ products: [FavoriteProductModel]) {
        view?.showFavorites(products)
    }

    func didFailFetchingFavorites(_ error: String) {
        view?.showError(error)
    }
}
