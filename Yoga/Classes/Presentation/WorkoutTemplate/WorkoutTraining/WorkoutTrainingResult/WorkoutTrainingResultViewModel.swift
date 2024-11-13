//
//  WorkoutTrainingResultViewModel.swift
//  Soccer
//
//  Created by Виталий Загороднов on 13.04.2023.
//

import Foundation
import RxCocoa
import RxSwift

final class WorkoutTrainingResultViewModel {
    lazy var skillLevel = makeSkillLevel()
    
    private let workoutTraining: Driver<WorkoutTraining>
    private lazy var contentManager = ContentManager()
    
    init(workoutTraining: WorkoutTraining) {
        self.workoutTraining = BehaviorRelay(value: workoutTraining).asDriver()
    }
}

// MARK: Public
extension WorkoutTrainingResultViewModel {
    func makeSkillLevel() -> Driver<SkillLevel> {
        workoutTraining
            .flatMapLatest { [weak self] workoutTraining -> Driver<SkillLevel> in
                guard let self = self else {
                    return .never()
                }
                
                return self.contentManager
                    .obtainLevels(forceUpdate: false)
                    .compactMap { skillLevels -> SkillLevel? in
                        skillLevels.first(where: { $0.id == workoutTraining.template.levelId })
                    }
                    .asDriver(onErrorDriveWith: .never())
            }
    }
}
