//
//  ProfileMainTableView.swift
//  Soccer
//
//  Created by Виталий Загороднов on 25.04.2023.
//

import UIKit
import RxCocoa

final class ProfileMainTableView: UITableView {
    lazy var didSelectDay = PublishRelay<Date>()
    lazy var didSelectCell = PublishRelay<ProfileMainTableElement>()
    private var elements = [ProfileMainTableElement]()

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ProfileMainTableView {
    func setup(elements: [ProfileMainTableElement]) {
        self.elements = elements
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension ProfileMainTableView: UITableViewDataSource {
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
        case .profile:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileDetailsCell.self)) as! ProfileDetailsCell
            return cell
        case .progress(let percent, let level):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProgressProfileCell.self)) as! ProgressProfileCell
            cell.setup(percent: percent, level: level)
            return cell
        case .calendar(let elements):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileCalendarCell.self)) as! ProfileCalendarCell
            cell.setup(elements: elements) { [weak self] in
                self?.didSelectDay.accept($0)
            }
            return cell
        case .planTraining(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: HomePlanTrainingCell.self), for: indexPath) as! HomePlanTrainingCell
            cell.setup(element: element)
            return cell
        case .noTrainings:
            return dequeueReusableCell(withIdentifier: String(describing: HomeNoTrainingsCell.self), for: indexPath)
        case .stats(let trainingCompletedSeconds):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ProfileMainStatsCell.self), for: indexPath) as! ProfileMainStatsCell
            cell.setup(trainingCompletedSeconds: trainingCompletedSeconds)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension ProfileMainTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .profile:
            return UITableView.automaticDimension
        case .progress:
            return 180.scale
        case .calendar:
            return 93.scale
        case .planTraining:
            return 122.scale
        case .noTrainings:
            return 122.scale
        case .stats:
            return 184.scale
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectCell.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension ProfileMainTableView {
    func initialize() {
        register(ProfileDetailsCell.self, forCellReuseIdentifier: String(describing: ProfileDetailsCell.self))
        register(ProfileCalendarCell.self, forCellReuseIdentifier: String(describing: ProfileCalendarCell.self))
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(HomePlanTrainingCell.self, forCellReuseIdentifier: String(describing: HomePlanTrainingCell.self))
        register(HomeNoTrainingsCell.self, forCellReuseIdentifier: String(describing: HomeNoTrainingsCell.self))
        register(ProgressProfileCell.self, forCellReuseIdentifier: String(describing: ProgressProfileCell.self))
        register(ProfileMainStatsCell.self, forCellReuseIdentifier: String(describing: ProfileMainStatsCell.self))
        
        dataSource = self
        delegate = self
    }
}
