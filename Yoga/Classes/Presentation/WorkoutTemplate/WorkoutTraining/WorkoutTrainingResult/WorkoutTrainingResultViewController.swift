//
//  WorkoutTrainingResultViewController.swift
//  Soccer
//
//  Created by Виталий Загороднов on 13.04.2023.
//

import UIKit
import RxSwift

class WorkoutTrainingResultViewController: UIViewController {
    lazy var mainView = WorkoutTrainingResultView(workoutTraining: workoutTraining)
    
    private lazy var viewModel = WorkoutTrainingResultViewModel(workoutTraining: workoutTraining)
    
    private lazy var disposeBag = DisposeBag()
    
    private let workoutTraining: WorkoutTraining
    
    private init(workoutTraining: WorkoutTraining) {
        self.workoutTraining = workoutTraining
        
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

        Observable
            .merge(
                mainView.closeButton.rx.tap.asObservable(),
                mainView.continueButton.rx.tap.asObservable()
            )
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.skillLevel
            .drive(Binder(mainView) { base, skillLevel in
                base.setup(skillLevel: skillLevel)
            })
            .disposed(by: disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

// MARK: Make
extension WorkoutTrainingResultViewController {
    static func make(workoutTraining: WorkoutTraining) -> WorkoutTrainingResultViewController {
        let vc = WorkoutTrainingResultViewController(workoutTraining: workoutTraining)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}
