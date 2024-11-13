//
//  TrainCollectionView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 13.03.2023.
//

import UIKit

final class TrainCollectionView: UICollectionView {
    var didTap: ((TrainTrainigElement.Training) -> Void)?
    
    lazy var elements = [TrainTrainigElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension TrainCollectionView {
    func setup(elements: [TrainTrainigElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension TrainCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: TrainCollectionCell.self), for: indexPath) as! TrainCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension TrainCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 254.scale, height: 330.scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let training = elements[indexPath.row].training
        didTap?(training)
    }
}

// MARK: Private
private extension TrainCollectionView {
    func initialize() {
        register(TrainCollectionCell.self, forCellWithReuseIdentifier: String(describing: TrainCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
