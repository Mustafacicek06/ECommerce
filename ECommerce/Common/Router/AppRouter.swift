//
//  AppRouter.swift
//  ECommerce
//
//  Created by Mustafa on 21.12.2024.
//

import UIKit

final class AppRouter {
    var window: UIWindow?
    let tabBarController = UITabBarController()

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        let tabBarController = createTabBarController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    private func createTabBarController() -> UITabBarController {
        let home = HomeRouter.createModule()
        let card = CartRouter.createModule()
        let favorite = FavoriteRouter.createModule()
        let account = HomeRouter.createModule()

        let nav1 = UINavigationController(rootViewController: home)
        nav1.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 0)

        let nav2 = UINavigationController(rootViewController: card)
        nav2.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "cart"), tag: 1)

        let nav3 = UINavigationController(rootViewController: favorite)
        // star icon
        nav3.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "star"), tag: 2)

        let nav4 = UINavigationController(rootViewController: account)
        nav4.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), tag: 3)

        tabBarController.viewControllers = [nav1, nav2, nav3, nav4]
        return tabBarController
    }

}
