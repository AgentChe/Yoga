//
//  HomeDrillCategoriesCollectionView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import UIKit

final class HomeDrillCategoriesCollectionView: UICollectionView {
    var didTap: ((DrillCategory) -> Void)?
    
    lazy var elements = [DrillCategory]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension HomeDrillCategoriesCollectionView {
    func setup(elements: [DrillCategory]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension HomeDrillCategoriesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: HomeDrillCategoriesCollectionCell.self), for: indexPath) as! HomeDrillCategoriesCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension HomeDrillCategoriesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        HomeDrillCategoriesCollectionCell.size(for: elements[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let drillCategory = elements[indexPath.row]
        didTap?(drillCategory)
    }
}

// MARK: Private
private extension HomeDrillCategoriesCollectionView {
    func initialize() {
        register(HomeDrillCategoriesCollectionCell.self, forCellWithReuseIdentifier: String(describing: HomeDrillCategoriesCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
