//
//  DailyPicksCollectionView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import UIKit

final class DailyPicksCollectionView: UICollectionView {
    var didTap: ((DailyPicksElement.DailyPicks) -> Void)?
    
    lazy var elements = [DailyPicksElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension DailyPicksCollectionView {
    func setup(elements: [DailyPicksElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension DailyPicksCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: DailyPicksCollectionCell.self), for: indexPath) as! DailyPicksCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension DailyPicksCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 254.scale, height: 330.scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dailyPicks = elements[indexPath.row].dailyPicks
        didTap?(dailyPicks)
    }
}

// MARK: Private
private extension DailyPicksCollectionView {
    func initialize() {
        register(DailyPicksCollectionCell.self, forCellWithReuseIdentifier: String(describing: DailyPicksCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
