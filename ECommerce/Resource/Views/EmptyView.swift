//
//  EmptyView.swift
//  ECommerce
//
//  Created by Mustafa Çiçek on 23.12.2024.
//

import UIKit

class EmptyView: UIView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.slash")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "There is no favorite product yet."
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        addAnimation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(imageView)
        addSubview(messageLabel)
    }

    private func setupConstraints() {
        imageView.centerInSuperview(offset: CGPoint(x: 0, y: -80))
        imageView.setSize(width: 100, height: 100)
        messageLabel.pinTopToBottom(of: imageView, offset: 16)
        messageLabel.pinToLeading(of: self, offset: 0)
        messageLabel.pinToTrailing(of: self, offset: 16)
    }

    private func addAnimation() {
        imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: [.curveEaseInOut, .allowUserInteraction]) {
            self.imageView.transform = .identity
        }
    }
}
