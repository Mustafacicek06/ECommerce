//
//  ProductDetailPresenter.swift
//  ECommerce
//
//  Created by Mustafa on 23.12.2024.
//

import Foundation

protocol ProductDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func toggleFavoriteStatus()
    func addToCart()
    func getProduct() -> Product
}

final class ProductDetailPresenter: ProductDetailPresenterProtocol {
    weak var view: ProductDetailViewProtocol?
    var interactor: ProductDetailInteractorProtocol?
    var router: ProductDetailRouterProtocol?

    private var product: Product

    init(product: Product) {
        self.product = product
    }
    
    func viewDidLoad() {
        view?.displayProductDetails(product: product)
    }

    func toggleFavoriteStatus() {
        interactor?.updateFavoriteStatus(for: product)
        view?.displayProductDetails(product: product)
    }

    func addToCart() {
        interactor?.addToCart(product: product)
    }
    
    func getProduct() -> Product {
        return product
    }
}
