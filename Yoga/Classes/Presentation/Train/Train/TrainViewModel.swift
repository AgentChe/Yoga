//
//  TrainViewModel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 13.03.2023.
//

import RxSwift
import RxCocoa

final class TrainViewModel {
    lazy var sections = makeSections()
    
    private lazy var workoutSteps = makeWorkoutSteps()
    private lazy var focusZones = makeFocusZones()
    private lazy var workoutCovers = makeWorkoutCovers()
    private lazy var skillLevel = makeSkillLevel()
    
    private lazy var workoutManager = WorkoutManager()
    private lazy var profileManger = ProfileManager()
    private lazy var contentManager = ContentManager()
}

// MARK: Private
private extension TrainViewModel {
    func makeSections() -> Driver<[TrainTableSection]> {
        Driver
            .combineLatest(
                skillLevel.asDriver(onErrorDriveWith: .never()),
                workoutCovers,
                focusZones,
                workoutSteps
            )
            .map { skillLevel, workoutCovers, focusZones, workoutSteps -> [TrainTableSection] in
                let workoutCoversSection = TrainTableSection(
                    elements: [
                        .title("Train.Workouts".localized),
                        .trainings(workoutCovers.map { workoutCover -> TrainTrainigElement in
                            TrainTrainigElement(
                                training: .workoutCover(workoutCover),
                                image: workoutCover.image,
                                name: workoutCover.name,
                                tag1: skillLevel.name,
                                tag2: String(format: "Train.ExercisesCount".localized, workoutCover.exercisesCount)
                            )
                        })
                    ]
                )
                
                let focusZonesSection = TrainTableSection(
                    elements: [
                        .title("Train.FocusZones".localized),
                        .trainings(focusZones.map { focusZone -> TrainTrainigElement in
                            TrainTrainigElement(
                                training: .focusZone(focusZone),
                                image: focusZone.image,
                                name: focusZone.name,
                                tag1: skillLevel.name,
                                tag2: String(format: "Train.ExercisesCount".localized, focusZone.exercisesCount)
                            )
                        })
                    ]
                )
                
                let workoutStepsSection = TrainTableSection(
                    elements: [
                        .title("Train.Steps".localized),
                        .trainings(workoutSteps.map { workoutStep -> TrainTrainigElement in
                            TrainTrainigElement(
                                training: .workoutStep(workoutStep),
                                image: workoutStep.image,
                                name: workoutStep.name,
                                tag1: skillLevel.name,
                                tag2: String(format: "Train.ExercisesCount".localized, workoutStep.exercisesCount)
                            )
                        })
                    ]
                )
                
                return [
                    workoutCoversSection,
                    focusZonesSection,
                    workoutStepsSection
                ]
            }
    }
    
    func makeWorkoutSteps() -> Driver<[WorkoutStep]> {
        workoutManager
            .obtainWorkoutSteps(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeFocusZones() -> Driver<[FocusZone]> {
        workoutManager
            .obtainFocusZones(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeWorkoutCovers() -> Driver<[WorkoutCover]> {
        workoutManager
            .obtainWorkoutCovers(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeSkillLevel() -> Driver<SkillLevel> {
        let skillLevelId = Driver
            .merge(
                profileManger
                    .obtainProfile(forceUpdate: false)
                    .compactMap { $0?.skillLevelId }
                    .asDriver(onErrorDriveWith: .never()),
                ProfileMediator.shared.skillLevelIdChange
                    .asDriver(onErrorDriveWith: .never())
            )
        
        return skillLevelId.flatMapLatest { [weak self] skillLevelId -> Driver<SkillLevel> in
            guard let self = self else {
                return .never()
            }
            
            return self.contentManager
                .obtainLevels(forceUpdate: false)
                .compactMap { skillLevels -> SkillLevel? in
                    skillLevels.first(where: { $0.id == skillLevelId })
                }
                .asDriver(onErrorDriveWith: .never())
        }
    }
}
