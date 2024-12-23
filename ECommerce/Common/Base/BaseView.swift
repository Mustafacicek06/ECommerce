//
//  BaseView.swift
//  ECommerce
//
//  Created by Mustafa on 23.12.2024.
//

import UIKit

class BaseView: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "E-Market"
        navigationController?.navigationBar.backgroundColor = AppColors.primaryColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
