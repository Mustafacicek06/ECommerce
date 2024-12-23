//
//  UIView+Constraints.swift
//  ECommerce
//
//  Created by Mustafa on 21.12.2024.
//

import UIKit

extension UIView {
    func pinToSuperviewEdges(insets: UIEdgeInsets = .zero) {
        guard let superview = superview else {
            fatalError("Cannot find superview.")
        }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
        ])
    }
    
    func setSize(width: CGFloat? = nil, height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centerInSuperview(offset: CGPoint = .zero) {
        guard let superview = superview else {
            fatalError("Cannot find superview.")
        }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: offset.x),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: offset.y)
        ])
    }
    
    func pinEdges(to view: UIView, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)
        ])
    }
    
    func pinTopToBottom(of view: UIView, offset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.bottomAnchor, constant: offset).isActive = true
    }
    
    func pinBottomToTop(of view: UIView, offset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        bottomAnchor.constraint(equalTo: view.topAnchor, constant: offset).isActive = true
    }
    
    func pinLeadingToTrailing(of view: UIView, offset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: offset).isActive = true
    }
    
    func pinTrailingToLeading(of view: UIView, offset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset).isActive = true
    }
    
    func pinToTop(of view: UIView, offset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor, constant: offset).isActive = true
    }
    
    func pinToBottom(of view: UIView, offset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: offset).isActive = true
    }
    
    func pinToLeading(of view: UIView, offset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset).isActive = true
    }
    
    func pinToTrailing(of view: UIView, offset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: offset).isActive = true
    }
    
    func centerX(to view: UIView, offset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset).isActive = true
    }
    
    func centerY(to view: UIView, offset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset).isActive = true
    }
}
