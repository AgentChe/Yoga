//
//  HomeDrillCategoriesCollectionLayout.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.02.2023.
//

import UIKit

final class HomeDrillCategoriesCollectionLayout: UICollectionViewFlowLayout {
    private var layoutInfo = [IndexPath: UICollectionViewLayoutAttributes]()
    private var contentWidth = CGFloat(0)
    
    override func prepare() {
        guard
            let collectionView = collectionView,
            let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout
        else {
            return
        }
        
        layoutInfo = [:]
        
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        
        var topRowX = sectionInset.left
        var bottomRowX = sectionInset.left
        
        for row in 0..<itemsCount {
            let indexPath = IndexPath(row: row, section: 0)
            let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            guard let itemSize = delegate.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) else {
                continue
            }
            
            let top = row % 2 == 0
            
            let y = top ? 0 : itemSize.height + minimumLineSpacing
            
            let position = CGPoint(x: top ? topRowX : bottomRowX, y: y)
            let frame = CGRect(origin: position, size: itemSize)
            
            let itemSpacing = row == (itemsCount - 1) ? 0 : minimumInteritemSpacing
            if top {
                topRowX += itemSize.width + itemSpacing
            } else {
                bottomRowX += itemSize.width + itemSpacing
            }
            
            itemAttributes.frame = frame
            layoutInfo[indexPath] = itemAttributes
        }
        
        contentWidth = max(topRowX, bottomRowX) + sectionInset.right
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        layoutInfo[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        
        layoutInfo.forEach { key, value in
            if rect.intersects(value.frame) {
                attributes.append(value)
            }
        }
        
        return attributes
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return .zero
        }
        
        return CGSize(width: contentWidth, height: collectionView.bounds.height)
    }
}
