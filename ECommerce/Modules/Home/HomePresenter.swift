//
//  HomePresenter.swift
//  ECommerce
//
//  Created by Mustafa on 21.12.2024.
//

import Foundation

protocol HomePresenterProtocol {
    var numberOfItems: Int { get }
    func viewDidLoad()
    func product(_ index: Int) -> Product?
    func pullToRefresh()
    func viewWillDisplay()
    func viewWillLayoutSubviews()
}

final class HomePresenter {
    private let view: HomeViewProtocol
    private let interactor: HomeInteractorProtocol
    
    private var products: [Product] = []
    private var next: String?
    
    init(view: HomeViewProtocol, interactor: HomeInteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }
    
    private func fetchData() {
        view.showLoadingView()
        interactor.fetchProducts(next: next)
    }
}

extension HomePresenter: HomePresenterProtocol {
    func viewWillLayoutSubviews() {
        view.prepareTableView()
    }
    
    var numberOfItems: Int {
        return products.count
    }
    
    func viewDidLoad() {
        fetchData()
    }
    
    func product(_ index: Int) -> Product? {
        return products[safe: index]
    }
    
    func pullToRefresh() {
        fetchData()
    }
    
    func viewWillDisplay() {
        guard let next else {
            view.showAlert(title: "No More Data", message: "There is no more data you can bring")
            return }
        fetchData()
    }
}

extension HomePresenter: HomeInteractorOuput {
    func handleProductResult(_ completionHandler: Result<[Product], NetworkError>) {
        view.hideLoadingView()
        switch completionHandler {
        case .success(let response):
            products.append(contentsOf: response)
            //products = products.unique()
            //next = response.next
            view.reloadData(items: products)
            view.endRefreshing()
        case .failure(let error):
            view.showError(error)
            products = []
            break
        }
    }
}
