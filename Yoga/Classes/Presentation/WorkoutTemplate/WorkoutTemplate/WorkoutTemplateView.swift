//
//  WorkoutTemplateView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.03.2023.
//

import UIKit

final class WorkoutTemplateView: UIView {
    lazy var tableView = makeTableView()
    lazy var preloader = makePreloader()
    lazy var screenPreloader = makeScreenPreloader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension WorkoutTemplateView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
}

// MARK: Make constraints
private extension WorkoutTemplateView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            screenPreloader.leadingAnchor.constraint(equalTo: leadingAnchor),
            screenPreloader.trailingAnchor.constraint(equalTo: trailingAnchor),
            screenPreloader.topAnchor.constraint(equalTo: topAnchor),
            screenPreloader.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WorkoutTemplateView {
    func makeTableView() -> WorkoutTemplateTableView {
        let view = WorkoutTemplateTableView()
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24.scale, right: 0)
        view.setContentOffset(CGPoint.zero, animated: false)
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 45.scale, height: 45.scale))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeScreenPreloader() -> ScreenPreloader {
        let view = ScreenPreloader()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
