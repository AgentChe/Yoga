//
//  TrainTableView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 13.03.2023.
//

import UIKit

protocol TrainTableDelegate: AnyObject {
    func trainTableDidTapped(training: TrainTrainigElement.Training)
}

final class TrainTableView: UITableView {
    weak var mainDelegate: TrainTableDelegate?
    
    lazy var sections = [TrainTableSection]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension TrainTableView {
    func setup(sections: [TrainTableSection]) {
        self.sections = sections
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension TrainTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section].elements[indexPath.row] {
        case .title(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: TrainTitleCell.self)) as! TrainTitleCell
            cell.setup(element: element)
            return cell
        case .trainings(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: TrainTrainingCell.self)) as! TrainTrainingCell
            cell.collectionView.setup(elements: element)
            cell.collectionView.didTap = { [weak self] training in
                self?.mainDelegate?.trainTableDidTapped(training: training)
            }
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension TrainTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section].elements[indexPath.row] {
        case .title:
            return 89.scale
        case .trainings:
            return 330.scale
        }
    }
}

// MARK: Private
private extension TrainTableView {
    func initialize() {
        register(TrainTitleCell.self, forCellReuseIdentifier: String(describing: TrainTitleCell.self))
        register(TrainTrainingCell.self, forCellReuseIdentifier: String(describing: TrainTrainingCell.self))
        
        dataSource = self
        delegate = self
    }
}
