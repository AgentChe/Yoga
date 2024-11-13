//
//  DTITableView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 09.02.2023.
//

import UIKit

protocol DTITableDelegate: AnyObject {
    func dtiTableDidTappedCalendar()
    func dtiTableDidTappedStartTraining()
}

final class DTITableView: UITableView {
    weak var mainDelegate: DTITableDelegate?
    
    lazy var elements = [DTITableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension DTITableView {
    func setup(elements: [DTITableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension DTITableView: UITableViewDataSource {
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
        case .header(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: DTIHeaderCell.self)) as! DTIHeaderCell
            cell.setup(element: element)
            return cell
        case .description(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: DTIDescriptionCell.self)) as! DTIDescriptionCell
            cell.setup(element: element)
            return cell
        case .buttons:
            let cell = dequeueReusableCell(withIdentifier: String(describing: DTIButtonsCell.self)) as! DTIButtonsCell
            cell.didTapCalendar = { [weak self] in
                self?.mainDelegate?.dtiTableDidTappedCalendar()
            }
            cell.didTapStart = { [weak self] in
                self?.mainDelegate?.dtiTableDidTappedStartTraining()
            }
            return cell
        case .instruction(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: DTIInstructionCell.self)) as! DTIInstructionCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension DTITableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .header:
            return 348.scale
        case .buttons:
            return 54.scale
        default:
            return UITableView.automaticDimension
        }
    }
}

// MARK: Private
private extension DTITableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(DTIHeaderCell.self, forCellReuseIdentifier: String(describing: DTIHeaderCell.self))
        register(DTIDescriptionCell.self, forCellReuseIdentifier: String(describing: DTIDescriptionCell.self))
        register(DTIButtonsCell.self, forCellReuseIdentifier: String(describing: DTIButtonsCell.self))
        register(DTIInstructionCell.self, forCellReuseIdentifier: String(describing: DTIInstructionCell.self))
        
        dataSource = self
        delegate = self
    }
}
