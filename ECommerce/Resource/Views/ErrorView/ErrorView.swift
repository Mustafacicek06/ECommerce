//
//  ErrorView.swift
//
//  Created by Mustafa on 22.10.2023.
//

import UIKit

final class ErrorView: UIView {
    private let errorImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "xmark.circle"))
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.tintColor = .systemRed
        return imageView
    }()

    private let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "An error occurred"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFonts.semiBoldLarge
        return label
    }()

    private let retryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Try Again", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemBlue
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = AppColors.primaryColor
        return button
    }()
    
    var retryButtonTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(errorImageView)
        addSubview(errorMessageLabel)
        addSubview(retryButton)

        errorImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        errorImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40).isActive = true

        errorMessageLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        errorMessageLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 20).isActive = true

        retryButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        retryButton.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 20).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMessage(_ message: String) {
        errorMessageLabel.text = message
        retryButton.addTarget(self, action: #selector(retryButtonOnTapped), for: .touchUpInside)
    }
    
    @objc func retryButtonOnTapped() {
        retryButtonTapped?()
    }
}
