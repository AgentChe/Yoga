//
//  DrillTrainingsTableView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import UIKit

protocol DrillsTableDelegate: AnyObject {
    func drillsTableDidTap(element: Drill)
}

final class DrillsTableView: UITableView {
    weak var mainDelegate: DrillsTableDelegate?
    
    lazy var elements = [HomeTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension DrillsTableView {
    func setup(elements: [HomeTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension DrillsTableView: UITableViewDataSource {
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
        case .drill(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: HomeDrillCoverCell.self)) as! HomeDrillCoverCell
            cell.setup(element: element)
            return cell
        default:
            return UITableViewCell(style: .default, reuseIdentifier: nil)
        }
    }
}

// MARK: UITableViewDelegate
extension DrillsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .drill:
            return 90.scale
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .drill(let element):
            mainDelegate?.drillsTableDidTap(element: element.drill)
        default:
            return
        }
    }
}

// MARK: Private
private extension DrillsTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(HomeDrillCoverCell.self, forCellReuseIdentifier: String(describing: HomeDrillCoverCell.self))
        
        dataSource = self
        delegate = self
    }
}
