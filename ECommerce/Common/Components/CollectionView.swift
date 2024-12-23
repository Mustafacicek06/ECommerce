//
//  CollectionView.swift
//  ECommerce
//
//  Created by Mustafa on 21.12.2024.
//

import UIKit

class CollectionView<T, Cell: UICollectionViewCell>: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Private Properties
    private var items: [T] = []
    private let configureCell: (Cell, T) -> Void
    private let cellIdentifier: String
    private let itemSize: CGSize
    
    // MARK: - Public Properties And Closures
    var willDisplayCell: ((Cell, IndexPath) -> Void)?
    
    private let collectionView: UICollectionView
    
    // MARK: - Initialization
    init(
        layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout(),
        cellClass: Cell.Type,
        cellIdentifier: String = Cell.identifier,
        itemSize: CGSize,
        configureCell: @escaping (Cell, T) -> Void
    ) {
        self.cellIdentifier = cellIdentifier
        self.configureCell = configureCell
        self.itemSize = itemSize
        
        // Configure layout
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: .zero)
        setupCollectionView(cellClass: cellClass)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupCollectionView(cellClass: Cell.Type) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellClass, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.backgroundColor = .white
    }
    
    private func setupUI() {
        addSubview(collectionView)
        collectionView.pinToSuperviewEdges()
    }
    
    // MARK: - Public Methods
    func updateItems(_ items: [T]) {
        self.items = items
        collectionView.reloadData()
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func getCollectionView() -> UICollectionView {
        return collectionView
    }
    
    // MARK: - CollectionView Delegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? Cell else { return UICollectionViewCell() }
        configureCell(cell, items[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? Cell {
            willDisplayCell?(cell, indexPath)
        }
    }
}
