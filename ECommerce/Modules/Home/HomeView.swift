//
//  HomeView.swift
//  ECommerce
//
//  Created by Mustafa on 21.12.2024.
//

import UIKit

protocol HomeViewProtocol: AnyObject {
    func showLoadingView()
    func hideLoadingView()
    func showError(_ error: NetworkError)
    func reloadData(items: [Product])
    func endRefreshing()
    func prepareTableView()
    func prepareNavigationBarUI()
    func showAlert(title: String, message: String)
}

final class HomeView: UIViewController, LoadingShowable {
    var presenter: HomePresenterProtocol?
    
    private let searchBar: UISearchBar = {
            let searchBar = UISearchBar()
            searchBar.placeholder = "Search"
            searchBar.layer.cornerRadius = 8
            searchBar.layer.masksToBounds = true
            return searchBar
        }()
    
    private let filterButton: UIButton = {
            let button = UIButton()
            button.setTitle("Select Filter", for: .normal)
            button.setTitleColor(.darkGray, for: .normal)
            button.backgroundColor = .lightGray
            button.layer.cornerRadius = 8
            return button
        }()
    
    private var collectionView: CollectionView<Product, ProductCell>?
    
    var errorView: ErrorView = ErrorView()
    
    lazy var refreshController: UIRefreshControl = {
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        presenter?.viewDidLoad()
        setupUI()
       
        setupCartBadgeObserver()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        prepareErrorView()
        presenter?.viewWillLayoutSubviews()
    }
    
    func setupCartBadgeObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge), name: .cartUpdated, object: nil)
    }
    
    @objc private func updateCartBadge() {
        let totalItems = CartManager.shared.totalItemCount
        let cartTabBarItem = tabBarController?.tabBar.items?[safe: 1] // Cart'ın olduğu tab
        cartTabBarItem?.badgeValue = totalItems > 0 ? "\(totalItems)" : nil
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(errorView)
        errorView.centerX(to: view)
        errorView.centerY(to: view)
        
        // Search Bar
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Filter Button
        view.addSubview(filterButton)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Collection View
        collectionView = CollectionView<Product, ProductCell>(
            cellClass: ProductCell.self,
            itemSize: CGSize(width: (view.frame.width - 48) / 2, height: 300),
            configureCell: { cell, product in
                cell.delegate = self
                cell.configure(with: product)
            }
        )
        
        if let collectionView = collectionView {
            view.addSubview(collectionView)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 16),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
                collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    }
    
    @objc func pullToRefresh() {
        presenter?.pullToRefresh()
    }
    
    private func prepareErrorView() {
        errorView.retryButtonTapped = errorButtonOnTapped
        errorView.setMessage("An error occurred")
    }
    
    private func errorButtonOnTapped() {
        presenter?.viewDidLoad()
    }
    
    private func collectionViewDisplay() {
        guard let collectionView else { return }
        collectionView.willDisplayCell = { [weak self] cell, indexPath in
            self?.presenter?.viewWillDisplay()
        }
    }
}

extension HomeView: ProductCellDelegate {
    func didTapFavoriteButton(in cell: ProductCell) {
        guard let indexPath = collectionView else { return }
        //products[indexPath.item].isFavorite.toggle() // Favori durumunu güncelle
        //print("Favori durum güncellendi: \(products[indexPath.item])")
    }
    
    func didTapAddToCartButton(in cell: ProductCell) {
        guard let indexPath = collectionView?.getCollectionView().indexPath(for: cell) else { return }
        var product = presenter?.product(indexPath.row)
        product?.cardQuantity = 1
        if let product = product {
            CartManager.shared.addItem(product)
            print("Sepete eklendi: \(product.name)")
        }
    }
    
}

extension HomeView: HomeViewProtocol, PopupShowable {
    func showAlert(title: String, message: String) {
        showPopup(title: title, message: message)
    }
    
    func showError(_ error: NetworkError) {
        errorView.isHidden = false
        collectionView?.isHidden = true
    }
    
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        hideLoading()
    }
    
    func reloadData(items: [Product]) {
        collectionView?.isHidden = false
        errorView.isHidden = true
        collectionView?.updateItems(items)
    }
    
    func endRefreshing() {
        collectionView?.getCollectionView().refreshControl?.endRefreshing()
    }
    
    func prepareTableView() {
        collectionView?.getCollectionView().refreshControl = refreshController
    }
    
    func prepareNavigationBarUI() {
        navigationItem.title = "Home"
    }
}
