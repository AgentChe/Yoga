//
//  ProfileDetailsTableView.swift
//  Soccer
//
//  Created by Виталий Загороднов on 29.04.2023.
//

import UIKit
import RxCocoa

final class ProfileDetailsTableView: UITableView {
    lazy var selectedCellModel = PublishRelay<ProfileDetailsTableElement>()
    
    private var elements = [ProfileDetailsTableElement]()

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ProfileDetailsTableView {
    func setup(elements: [ProfileDetailsTableElement]) {
        self.elements = elements
        reloadData()
    }
}


// MARK: UITableViewDataSource
extension ProfileDetailsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .item(let type, let isLast, let subtitle):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileDetailsItemCell.self)) as! ProfileDetailsItemCell
            cell.setup(type: type, isLast: isLast, subtitle: subtitle)
            return cell
        case .header(let title):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileDetailsHeaderCell.self)) as! ProfileDetailsHeaderCell
            cell.setup(title: title)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension ProfileDetailsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .header:
            return UITableView.automaticDimension
        case .item:
            return 64.scale
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellModel.accept(elements[indexPath.row])
    }
}


// MARK: Private
private extension ProfileDetailsTableView {
    func initialize() {
        register(ProfileDetailsItemCell.self, forCellReuseIdentifier: String(describing: ProfileDetailsItemCell.self))
        register(ProfileDetailsHeaderCell.self, forCellReuseIdentifier: String(describing: ProfileDetailsHeaderCell.self))
        
        dataSource = self
        delegate = self
    }
}
