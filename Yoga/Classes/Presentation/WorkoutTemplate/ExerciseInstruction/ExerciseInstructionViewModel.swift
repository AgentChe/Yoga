//
//  ExerciseInstructionViewModel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 15.03.2023.
//

import RxSwift
import RxCocoa

final class ExerciseInstructionViewModel {
    lazy var elements = makeElements()
    
    private let exercise: Driver<WorkoutExercise>
    
    init(exercise: WorkoutExercise) {
        self.exercise = BehaviorRelay(value: exercise).asDriver()
    }
}

// MARK: Private
private extension ExerciseInstructionViewModel {
    func makeElements() -> Driver<[ExerciseInstructionTableElement]> {
        exercise
            .map { exercise -> [ExerciseInstructionTableElement] in
                [
                    .image(exercise.image),
                    .offset(16.scale),
                    .name(exercise.name),
                    .offset(24.scale),
                    .instruction(exercise.instruction)
                ]
            }
    }
}
