//
//  HomeInteractor.swift
//  ECommerce
//
//  Created by Mustafa on 21.12.2024.
//

import Foundation

protocol HomeInteractorProtocol {
    func fetchProducts(next: String?)
}

protocol HomeInteractorOuput: AnyObject {
    func handleProductResult(_ completionHandler: Result<[Product], NetworkError>)
}

final class HomeInteractor {
    weak var output: HomeInteractorOuput?
}

extension HomeInteractor: HomeInteractorProtocol {
    func fetchProducts(next: String? = nil) {
        NetworkManager.shared.request(
            path: NetworkPaths.products.rawValue,
            method: .get,
            headers: nil,
            parameters: nil,
            responseType: [Product].self
        ) { result in
            switch result {
            case .success(let products):
                print("Products fetched successfully:")
                self.output?.handleProductResult(.success(products))
            case .failure(let error):
                self.output?.handleProductResult(.failure(error))
            }
        }
    }
}
