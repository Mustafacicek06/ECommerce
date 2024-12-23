//
//  CardRouter.swift
//  ECommerce
//
//  Created by Mustafa on 23.12.2024.
//

import UIKit

final class CartRouter {
    weak var navigationVC: UINavigationController?
    
    init(navigationVC: UINavigationController? = nil) {
        self.navigationVC = navigationVC
    }
    
    static func createModule() -> CartView {
        let view = CartView()
        //let interactor = HomeInteractor()
        let router = CartRouter()
        //let presenter = HomePresenter(view: view, interactor: interactor)
        
        //view.presenter = presenter
        //interactor.output = presenter
        
        return view
    }
}
