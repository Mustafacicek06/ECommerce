//
//  FavoriteView.swift
//  ECommerce
//
//  Created by Mustafa on 23.12.2024.
//

import UIKit

protocol FavoriteViewProtocol: AnyObject {
    func showFavorites(_ products: [FavoriteProductModel])
    func showError(_ message: String)
}

final class FavoriteView: UIViewController {
    var presenter: FavoritePresenterProtocol?

    private var collectionView: CollectionView<Product, ProductCell>?
    private var emptyView: EmptyView?

    private var favoriteProducts: [FavoriteProductModel] = [] {
        didSet {
            updateView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupEmptyView()
        presenter?.viewDidLoad()
        title = "Favorites"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewDidLoad()
    }

    private func setupTableView() {
        collectionView = CollectionView<Product, ProductCell>(
            cellClass: ProductCell.self,
            itemSize: CGSize(width: (view.frame.width - 48) / 2, height: 300),
            configureCell: { cell, product in
                cell.delegate = self
                cell.configure(with: product)
            }
        )
        
        guard let collectionView = collectionView else { return }
        view.addSubview(collectionView)
        collectionView.pinToSuperviewEdges()
    }
    
    private func setupEmptyView() {
        emptyView = EmptyView()
        if let emptyView = emptyView {
            view.addSubview(emptyView)
            emptyView.pinToSuperviewEdges()
            emptyView.isHidden = true
        }
    }
    
    private func updateView() {
        let hasFavorites = !favoriteProducts.isEmpty
        collectionView?.isHidden = !hasFavorites
        emptyView?.isHidden = hasFavorites
    }
}

extension FavoriteView: ProductCellDelegate {
    func didTapAddToCartButton(in cell: ProductCell) {
        guard let indexPath = collectionView?.getCollectionView().indexPath(for: cell) else { return }
        let favorite = favoriteProducts[safe: indexPath.row]
        let product = Product(name: favorite?.name, image: favorite?.imageURL, price: favorite?.price, id: favorite?.id, isFavorite: true, cardQuantity: 1)
        
        CartManager.shared.addItem(product)
        print("Sepete eklendi: \(product.name)")
    }
    
    func didTapFavoriteButton(in cell: ProductCell) {
        guard let indexPath = collectionView?.getCollectionView().indexPath(for: cell), let deleteId = favoriteProducts[safe: indexPath.row]?.id else { return }
        presenter?.didSelectDelete(for: deleteId)
    }
}

extension FavoriteView: FavoriteViewProtocol {
    func showFavorites(_ products: [FavoriteProductModel]) {
        favoriteProducts = products
        collectionView?.updateItems(products.map { Product(name: $0.name, image: $0.imageURL, price: $0.price, id: $0.id, isFavorite: true) })
    }

    func showError(_ message: String) {
        // Hata mesajını göster
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
