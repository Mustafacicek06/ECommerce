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
    
    private init() {
        let cartModels = CoreDataManager.shared.fetch(CartModel.self)
        cartItems = cartModels.map {
            Product(name: $0.name, image: nil, price: $0.price, id: $0.id, cardQuantity: Int($0.count))
        }
    }
    
    func addItem(_ item: Product) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            cartItems[index].cardQuantity = (cartItems[index].cardQuantity ?? 0) + (item.cardQuantity ?? 0)
            // coredata update
            let predicate = NSPredicate(format: "id == %@", item.id ?? "")
            CoreDataManager.shared.update(CartModel.self, predicate: predicate, configure: { (cart) in
                cart.count = Int16((cartItems[index].cardQuantity ?? 0) + (item.cardQuantity ?? 0))
            })
        } else {
            CoreDataManager.shared.insert(CartModel.self, configure: { (cart) in
                cart.id = item.id
                cart.count = Int16(item.cardQuantity ?? 0)
                cart.name = item.name
                cart.price = item.price
            })
            cartItems.append(item)
        }
        postCartUpdateNotification()
    }
    
    func removeItem(_ item: Product) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            cartItems.remove(at: index)
            // coredata delete
            let predicate = NSPredicate(format: "id == %@", item.id ?? "")
            CoreDataManager.shared.delete(CartModel.self, predicate: predicate)
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
