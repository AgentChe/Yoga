//
//  TrainView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 13.03.2023.
//

import UIKit

final class TrainView: UIView {
    lazy var infoButton = makeInfoButton()
    lazy var tableView = makeTableView()
    
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
private extension TrainView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
}

// MARK: Make constraints
private extension TrainView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            infoButton.widthAnchor.constraint(equalToConstant: 24.scale),
            infoButton.heightAnchor.constraint(equalToConstant: 24.scale),
            infoButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 50.scale : 20.scale),
            infoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: infoButton.bottomAnchor, constant: 14.scale),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TrainView {
    func makeInfoButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Train.Info"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> TrainTableView {
        let view = TrainTableView()
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16.scale, right: 0)
        view.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        view.separatorStyle = .none
        view.layoutMargins = UIEdgeInsets.zero
        if #available(iOS 15.0, *) {
            view.sectionHeaderTopPadding = 0
        }
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
