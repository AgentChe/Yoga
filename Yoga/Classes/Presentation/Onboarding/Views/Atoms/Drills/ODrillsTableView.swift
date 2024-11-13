//
//  ODrillsTableView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.02.2023.
//

import UIKit

final class ODrillsTableView: UITableView {
    var didChangeSelected: (() -> Void)?
    
    lazy var elements = [ODrillsTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ODrillsTableView {
    func setup(elements: [ODrillsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension ODrillsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: ODrillsTableCell.self)) as! ODrillsTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension ODrillsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        96.scale
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        elements[indexPath.row].marked.toggle()
        
        reloadRows(at: [indexPath], with: .none)
        
        didChangeSelected?()
    }
}

// MARK: Private
private extension ODrillsTableView {
    func initialize() {
        register(ODrillsTableCell.self, forCellReuseIdentifier: String(describing: ODrillsTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
