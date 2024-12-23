//
//  FavoriteRouter.swift
//  ECommerce
//
//  Created by Mustafa Çiçek on 23.12.2024.
//

import UIKit

protocol FavoriteRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
}

final class FavoriteRouter: FavoriteRouterProtocol {
    static func createModule() -> UIViewController {
        let view = FavoriteView()
        let presenter = FavoritePresenter()
        let interactor = FavoriteInteractor()
        let router = FavoriteRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        return view
    }
}
