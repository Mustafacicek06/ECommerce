//
//  ProductDetailRouter.swift
//  ECommerce
//
//  Created by Mustafa on 23.12.2024.
//

import UIKit

protocol ProductDetailRouterProtocol: AnyObject {
    func showCart()
}

final class ProductDetailRouter: ProductDetailRouterProtocol {
    weak var viewController: UIViewController?

    func showCart() {
        let cartView = CartRouter.createModule()
        viewController?.navigationController?.pushViewController(cartView, animated: true)
    }

    static func createModule(with product: Product) -> UIViewController {
        let view = ProductDetailView()
        let presenter = ProductDetailPresenter(product: product)
        let interactor = ProductDetailInteractor()
        let router = ProductDetailRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.viewController = view

        return view
    }
}
