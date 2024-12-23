//
//  HomeRouter.swift
//  ECommerce
//
//  Created by Mustafa on 21.12.2024.
//

import UIKit

final class HomeRouter {
    weak var navigationVC: UINavigationController?
    
    init(navigationVC: UINavigationController? = nil) {
        self.navigationVC = navigationVC
    }
    
    static func createModule() -> HomeView {
        let view = HomeView()
        let interactor = HomeInteractor()
        let router = HomeRouter()
        let presenter = HomePresenter(view: view, interactor: interactor)
        
        view.presenter = presenter
        interactor.output = presenter
        
        return view
    }
}
