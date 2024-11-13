//
//  WTFocusZonesCollectionView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.03.2023.
//

import UIKit

final class WTFocusZonesCollectionView: UICollectionView {
    var didTap: ((FocusZone) -> Void)?
    
    lazy var elements = [FocusZone]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WTFocusZonesCollectionView {
    func setup(elements: [FocusZone]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension WTFocusZonesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WTFocusZonesCollectionCell.self), for: indexPath) as! WTFocusZonesCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension WTFocusZonesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        WTFocusZonesCollectionCell.size(for: elements[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let focusZone = elements[indexPath.row]
        didTap?(focusZone)
    }
}

// MARK: Private
private extension WTFocusZonesCollectionView {
    func initialize() {
        register(WTFocusZonesCollectionCell.self, forCellWithReuseIdentifier: String(describing: WTFocusZonesCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
