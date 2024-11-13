//
//  WorkoutTrainingCollectionView.swift
//  Soccer
//
//  Created by Виталий Загороднов on 04.04.2023.
//

import UIKit

class WorkoutTrainingCollectionView: UICollectionView {
    
    lazy var elements = [WorkoutExercise]()

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WorkoutTrainingCollectionView {
    func setup(elements: [WorkoutExercise]) {
        self.elements = elements
        reloadData()
    }
    
}
// MARK: UICollectionViewDataSource
extension WorkoutTrainingCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WorkoutTrainingImageViewCell.self), for: indexPath) as! WorkoutTrainingImageViewCell
        
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension WorkoutTrainingCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 552.scale)
    }
}

// MARK: Private
private extension WorkoutTrainingCollectionView {
    func initialize() {
        register(WorkoutTrainingImageViewCell.self, forCellWithReuseIdentifier: String(describing: WorkoutTrainingImageViewCell.self))
        
        dataSource = self
        delegate = self
        isPagingEnabled = true
    }
}
