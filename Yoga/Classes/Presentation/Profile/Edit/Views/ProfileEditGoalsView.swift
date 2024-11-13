//
//  ProfileEditGoalsView.swift
//  WallPilates
//
//  Created by Андрей Чернышев on 07.03.2024.
//

import UIKit
import RxSwift

final class ProfileEditGoalsView: UIView {
    var didTapSave: (([DrillCategory]) -> Void)?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var tableView = makeTableView()
    lazy var continueButton = makeContinueButton()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var drillManager = DrillManager()
    
    private let initialSelectedGoals: [DrillCategory]
    
    init(goals: [DrillCategory]) {
        self.initialSelectedGoals = goals
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ProfileEditGoalsView {
    func initialize() {
        backgroundColor = Appearance.main100
        
        tableView.didChangeSelected = { [weak self] in
            self?.checkEnabled()
        }
        
        drillManager
            .obtainDrillCategories(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
            .drive(Binder(self) { base, drillCategories in
                let elements = drillCategories.map { goal -> ODrillsTableElement in
                    ODrillsTableElement(
                        drillCategory: goal,
                        marked: base.initialSelectedGoals.contains(where: { $0.id == goal.id })
                    )
                }
                base.tableView.setup(elements: elements)
            })
            .disposed(by: disposeBag)
    }
    
    func checkEnabled() {
        let marked = tableView.elements.contains(where: { $0.marked })
        continueButton.isHidden = !marked
    }
    
    @objc
    func nextTapped() {
        let goals = tableView.elements
            .filter { $0.marked }
            .map { $0.drillCategory }
        
        didTapSave?(goals)
    }
}

// MARK: Make constraints
private extension ProfileEditGoalsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 120.scale : 52.scale),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.scale),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 54.scale),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -62.scale : -32.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ProfileEditGoalsView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.bold(size: 24.scale))
            .lineHeight(28.8.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Drills.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> ODrillsTableView {
        let view = ODrillsTableView()
        view.contentInset = UIEdgeInsets(top: 8.scale,
                                         left: 0,
                                         bottom: (ScreenSize.isIphoneXFamily ? 62.scale : 32.scale) + 66.scale,
                                         right: 0)
        view.setContentOffset(CGPoint(x: 0, y: 8.scale), animated: false)
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.semiBold(size: 16.scale))
        
        let view = UIButton()
        view.backgroundColor = Appearance.main300
        view.layer.cornerRadius = 28.scale
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
