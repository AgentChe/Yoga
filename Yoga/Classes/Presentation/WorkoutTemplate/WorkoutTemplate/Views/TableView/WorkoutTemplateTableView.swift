//
//  WorkoutTemplateTableView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.03.2023.
//

import UIKit

protocol WorkoutTemplateTableDelegate: AnyObject {
    func tableDidTappedCalendar()
    func tableDidTappedStartTraining()
    func tableDidTapped(focusZone: FocusZone)
    func tableDidTapped(exercise: WorkoutExercise)
}

final class WorkoutTemplateTableView: UITableView {
    weak var mainDelegate: WorkoutTemplateTableDelegate?
    
    lazy var elements = [WorkoutTemplateTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WorkoutTemplateTableView {
    func setup(elements: [WorkoutTemplateTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension WorkoutTemplateTableView: UITableViewDataSource {
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
            let cell = dequeueReusableCell(withIdentifier: String(describing: WorkoutTemplateHeaderCell.self)) as! WorkoutTemplateHeaderCell
            cell.setup(element: element)
            return cell
        case .buttons:
            let cell = dequeueReusableCell(withIdentifier: String(describing: WorkoutTemplateButtonsCell.self)) as! WorkoutTemplateButtonsCell
            cell.didTapCalendar = { [weak self] in
                self?.mainDelegate?.tableDidTappedCalendar()
            }
            cell.didTapStart = { [weak self] in
                self?.mainDelegate?.tableDidTappedStartTraining()
            }
            return cell
        case .focusZones(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: WorkoutTemplateFocusZonesCell.self)) as! WorkoutTemplateFocusZonesCell
            cell.collectionView.setup(elements: element)
            cell.collectionView.didTap = { [weak self] focusZone in
                self?.mainDelegate?.tableDidTapped(focusZone: focusZone)
            }
            return cell
        case .title(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: WorkoutTemplateTitleCell.self)) as! WorkoutTemplateTitleCell
            cell.setup(element: element)
            return cell
        case .exercise(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: WorkoutTemplateExerciseCell.self)) as! WorkoutTemplateExerciseCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension WorkoutTemplateTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .header:
            return 348.scale
        case .buttons:
            return 54.scale
        case .focusZones:
            return 86.scale
        case .title:
            return UITableView.automaticDimension
        case .exercise:
            return 90.scale
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let .exercise(exercise) = elements[indexPath.row] else {
            return
        }
        
        mainDelegate?.tableDidTapped(exercise: exercise)
    }
}

// MARK: Private
private extension WorkoutTemplateTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(WorkoutTemplateHeaderCell.self, forCellReuseIdentifier: String(describing: WorkoutTemplateHeaderCell.self))
        register(WorkoutTemplateButtonsCell.self, forCellReuseIdentifier: String(describing: WorkoutTemplateButtonsCell.self))
        register(WorkoutTemplateFocusZonesCell.self, forCellReuseIdentifier: String(describing: WorkoutTemplateFocusZonesCell.self))
        register(WorkoutTemplateTitleCell.self, forCellReuseIdentifier: String(describing: WorkoutTemplateTitleCell.self))
        register(WorkoutTemplateExerciseCell.self, forCellReuseIdentifier: String(describing: WorkoutTemplateExerciseCell.self))
        
        dataSource = self
        delegate = self
    }
}
