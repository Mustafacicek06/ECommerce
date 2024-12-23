//
//  CardView.swift
//  ECommerce
//
//  Created by Mustafa on 23.12.2024.
//

import UIKit

class CartView: UIViewController {
    private var tableView: UITableView!
    private var cartItems: [Product] {
        return CartManager.shared.cartItems // Sepet öğelerini CartManager'dan al
    }

    private let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Complete", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppColors.primaryColor
        button.layer.cornerRadius = 8

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupTotalView()
        updateTotalPrice()
        NotificationCenter.default.addObserver(self, selector: #selector(cartDidUpdate), name: .cartUpdated, object: nil)
    }

    private func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CardCell.self, forCellReuseIdentifier: CardCell.identifier)
        view.addSubview(tableView)
        tableView.separatorStyle = .none

        // Constraint'ler
        tableView.pinToSuperviewEdges(insets: UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)) // FooterView için alt boşluk
    }

    private func setupTotalView() {
        let footerView = UIView()
        footerView.backgroundColor = .white

        let stackView = UIStackView(arrangedSubviews: [totalLabel, completeButton])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .fill

        footerView.addSubview(stackView)
        stackView.pinToSuperviewEdges(insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))

        view.addSubview(footerView)
        footerView.pinToBottom(of: view)
        footerView.pinToLeading(of: view)
        footerView.pinToTrailing(of: view)

        footerView.setSize(height: 60)
    }

    private func updateTotalPrice() {
        // price to ınt and sum
        let total = cartItems.reduce(0) { $0 + (Int($1.price ?? "5") ?? 5) * ($1.cardQuantity ?? 0) }
        totalLabel.text = "Total: \(total)₺"
    }
    
    @objc private func cartDidUpdate() {
        tableView.reloadData()
        updateTotalPrice()
    }
}

extension CartView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardCell.identifier, for: indexPath) as? CardCell else {
            return UITableViewCell()
        }
        cell.configure(with: cartItems[indexPath.row])
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension CartView: CartCellDelegate {
    func didUpdateQuantity(for cell: CardCell, to newQuantity: Int) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        //cartItems[indexPath.row].cardQuantity = newQuantity
        updateTotalPrice()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
