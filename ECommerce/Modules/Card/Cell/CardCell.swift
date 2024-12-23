//
//  CardCell.swift
//  ECommerce
//
//  Created by Mustafa on 23.12.2024.
//

import UIKit

protocol CartCellDelegate: AnyObject {
    func didUpdateQuantity(for cell: CardCell, to newQuantity: Int)
}

class CardCell: UITableViewCell {
    static let identifier = "CardCell"
    weak var delegate: CartCellDelegate?

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.regularNormal
        label.textColor = .black
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .blue
        return label
    }()

    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.regularLarge
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = AppColors.primaryColor
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return label
    }()

    private let minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray.withAlphaComponent(0.5)
        button.layer.cornerRadius = 4
        return button
    }()

    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray.withAlphaComponent(0.5)
        button.layer.cornerRadius = 4
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let quantityStack = UIStackView(arrangedSubviews: [minusButton, quantityLabel, plusButton])
        quantityStack.axis = .horizontal
        quantityStack.spacing = 0
        quantityStack.distribution = .fillEqually
        
        let nameAndPriceLabelStack = UIStackView(arrangedSubviews: [nameLabel, priceLabel])
        nameAndPriceLabelStack.axis = .vertical
        nameAndPriceLabelStack.spacing = 4
        nameAndPriceLabelStack.alignment = .leading
        nameAndPriceLabelStack.distribution = .fill

        let mainStack = UIStackView(arrangedSubviews: [nameAndPriceLabelStack, quantityStack])
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.spacing = 16
        mainStack.distribution = .fill

        contentView.addSubview(mainStack)
        mainStack.pinToSuperviewEdges(insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))

        minusButton.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
    }

    func configure(with item: Product) {
        nameLabel.text = item.name
        priceLabel.text = "\(item.price ?? "0")₺"
        quantityLabel.text = "\(item.cardQuantity ?? 0)"
    }

    @objc private func decreaseQuantity() {
        guard let quantity = Int(quantityLabel.text ?? ""), quantity > 1 else { return }
        delegate?.didUpdateQuantity(for: self, to: quantity - 1)
    }

    @objc private func increaseQuantity() {
        guard let quantity = Int(quantityLabel.text ?? "") else { return }
        delegate?.didUpdateQuantity(for: self, to: quantity + 1)
    }
}
