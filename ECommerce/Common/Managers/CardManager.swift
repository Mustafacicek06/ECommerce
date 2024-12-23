//
//  CardManager.swift
//  ECommerce
//
//  Created by Mustafa on 23.12.2024.
//

import Foundation

class CartManager {
    static let shared = CartManager()
    
    private(set) var cartItems: [Product] = []
    
    var totalItemCount: Int {
        return cartItems.reduce(0) { $0 + ($1.cardQuantity ?? 0) }
    }
    
    private init() {}
    
    func addItem(_ item: Product) {
        if let index = cartItems.firstIndex(where: { $0.name == item.name }) {
            // Ürün zaten varsa miktarını artır
            cartItems[index].cardQuantity = (cartItems[index].cardQuantity ?? 0) + (item.cardQuantity ?? 0)
        } else {
            // Ürün yeni ise ekle
            cartItems.append(item)
        }
        postCartUpdateNotification()
    }
    
    private func postCartUpdateNotification() {
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }
}

extension Notification.Name {
    static let cartUpdated = Notification.Name("cartUpdated")
}
