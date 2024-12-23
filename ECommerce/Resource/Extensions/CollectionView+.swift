//
//  CollectionView+.swift
//  ECommerce
//
//  Created by Mustafa on 21.12.2024.
//

import UIKit

public extension UICollectionViewCell {
    static var identifier: String {
        String(describing: type(of: self))
    }
}
