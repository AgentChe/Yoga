//
//  ExerciseInstructionViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 15.03.2023.
//

import UIKit
import RxSwift

final class ExerciseInstructionViewController: UIViewController {
    lazy var mainView = ExerciseInstructionView()
    
    private let viewModel: ExerciseInstructionViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private init(exercise: WorkoutExercise) {
        viewModel = ExerciseInstructionViewModel(exercise: exercise)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension ExerciseInstructionViewController {
    static func make(exercise: WorkoutExercise) -> ExerciseInstructionViewController {
        ExerciseInstructionViewController(exercise: exercise)
    }
}
