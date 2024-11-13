//
//  ExerciseInstructionTableView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 15.03.2023.
//

import UIKit

final class ExerciseInstructionTableView: UITableView {
    lazy var elements = [ExerciseInstructionTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ExerciseInstructionTableView {
    func setup(elements: [ExerciseInstructionTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension ExerciseInstructionTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .offset:
            let cell = dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        case .image(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ExerciseInstructionImageCell.self)) as! ExerciseInstructionImageCell
            cell.setup(element: element)
            return cell
        case .name(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ExerciseInstructionNameCell.self)) as! ExerciseInstructionNameCell
            cell.setup(element: element)
            return cell
        case .instruction(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ExerciseInstructionInstructionCell.self)) as! ExerciseInstructionInstructionCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension ExerciseInstructionTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .image:
            return 234.scale
        default:
            return UITableView.automaticDimension
        }
    }
}

// MARK: Private
private extension ExerciseInstructionTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(ExerciseInstructionImageCell.self, forCellReuseIdentifier: String(describing: ExerciseInstructionImageCell.self))
        register(ExerciseInstructionNameCell.self, forCellReuseIdentifier: String(describing: ExerciseInstructionNameCell.self))
        register(ExerciseInstructionInstructionCell.self, forCellReuseIdentifier: String(describing: ExerciseInstructionInstructionCell.self))
        
        dataSource = self
        delegate = self
    }
}
