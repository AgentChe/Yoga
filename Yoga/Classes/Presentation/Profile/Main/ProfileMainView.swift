//
//  ProfileMainView.swift
//  Soccer
//
//  Created by Виталий Загороднов on 25.04.2023.
//

import UIKit

final class ProfileMainView: UIView {
    lazy var tableView = makeTableView()
    lazy var preloader = makePreloader()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ProfileMainView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
}

// MARK: Make constraints
private extension ProfileMainView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 44.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.leadingAnchor.constraint(equalTo: leadingAnchor),
            preloader.trailingAnchor.constraint(equalTo: trailingAnchor),
            preloader.topAnchor.constraint(equalTo: topAnchor),
            preloader.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ProfileMainView {
    func makeTableView() -> ProfileMainTableView {
        let view = ProfileMainTableView()
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> ScreenPreloader {
        let view = ScreenPreloader()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
