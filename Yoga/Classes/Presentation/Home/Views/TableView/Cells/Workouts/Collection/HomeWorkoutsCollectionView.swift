//
//  HomeWorkoutsCollectionView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.02.2023.
//

import UIKit

final class HomeWorkoutsCollectionView: UICollectionView {
    var didTap: ((WorkoutCover) -> Void)?
    
    lazy var elements = [HomeWorkoutElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension HomeWorkoutsCollectionView {
    func setup(elements: [HomeWorkoutElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension HomeWorkoutsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: HomeWorkoutsCollectionCell.self), for: indexPath) as! HomeWorkoutsCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension HomeWorkoutsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 254.scale, height: 330.scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let workout = elements[indexPath.row].workout
        didTap?(workout)
    }
}

// MARK: Private
private extension HomeWorkoutsCollectionView {
    func initialize() {
        register(HomeWorkoutsCollectionCell.self, forCellWithReuseIdentifier: String(describing: HomeWorkoutsCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
