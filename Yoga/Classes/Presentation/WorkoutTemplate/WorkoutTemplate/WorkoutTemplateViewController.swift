//
//  WorkoutTemplateViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.03.2023.
//

import UIKit
import RxSwift

final class WorkoutTemplateViewController: UIViewController {
    lazy var mainView = WorkoutTemplateView()
    
    private let viewModel: WorkoutTemplateViewModel
    
    private lazy var workoutTrainingAssembly = WorkoutTrainingAssembly()
    
    private lazy var disposeBag = DisposeBag()
    
    private init(workoutCover: WorkoutCover) {
        viewModel = WorkoutTemplateViewModel(source: .cover(workoutCover))
        
        super.init(nibName: nil, bundle: nil)
    }
    
    private init(focusZone: FocusZone) {
        viewModel = WorkoutTemplateViewModel(source: .focusZone(focusZone))
        
        super.init(nibName: nil, bundle: nil)
    }
    
    private init(workoutStep: WorkoutStep) {
        viewModel = WorkoutTemplateViewModel(source: .step(workoutStep))
        
        super.init(nibName: nil, bundle: nil)
    }
    
    private init(workoutTemplate: WorkoutTemplate) {
        viewModel = WorkoutTemplateViewModel(source: .template(workoutTemplate))
        
        super.init(nibName: nil, bundle: nil)
    }
    
    private init(planWorkout: PlanWorkout) {
        viewModel = WorkoutTemplateViewModel(source: .plan(planWorkout))
        
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
        
        AmplitudeManager.shared
            .logEvent(name: "Workout Screen")
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.open(error: error)
        }
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        viewModel.assignActivity
            .drive(Binder(self) { base, activity in
                base.assignActivity(activity)
            })
            .disposed(by: disposeBag)
        
        viewModel.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        viewModel.route
            .drive(with: self) { $0.route($1) }
            .disposed(by: disposeBag)
        
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Make
extension WorkoutTemplateViewController {
    static func make(workoutCover: WorkoutCover) -> WorkoutTemplateViewController {
        let vc = WorkoutTemplateViewController(workoutCover: workoutCover)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
    
    static func make(focusZone: FocusZone) -> WorkoutTemplateViewController {
        let vc = WorkoutTemplateViewController(focusZone: focusZone)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
    
    static func make(workoutStep: WorkoutStep) -> WorkoutTemplateViewController {
        let vc = WorkoutTemplateViewController(workoutStep: workoutStep)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
    
    static func make(workoutTemplate: WorkoutTemplate) -> WorkoutTemplateViewController {
        let vc = WorkoutTemplateViewController(workoutTemplate: workoutTemplate)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
    
    static func make(planWorkout: PlanWorkout) -> WorkoutTemplateViewController {
        let vc = WorkoutTemplateViewController(planWorkout: planWorkout)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}


// MARK: WorkoutTemplateTableDelegate
extension WorkoutTemplateViewController: WorkoutTemplateTableDelegate {
    func tableDidTappedCalendar() {
        viewModel.didTapCalendar.accept(())
    }
    
    func tableDidTappedStartTraining() {
        viewModel.didTapStartTraining.accept(Void())
    }
    
    func tableDidTapped(focusZone: FocusZone) {
        let vc = WorkoutTemplateViewController.make(focusZone: focusZone)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableDidTapped(exercise: WorkoutExercise) {
        let vc = ExerciseInstructionViewController.make(exercise: exercise)
        present(vc, animated: true)
    }
}

// MARK: Private
private extension WorkoutTemplateViewController {
    func route(_ route: WorkoutTemplateViewModel.Route) {
        switch route {
        case .training(let customerWorkoutId):
            AmplitudeManager.shared
                .logEvent(name: "Workout Tap", parameters: ["what": "start"])
            
            workoutTrainingAssembly.startTraining(from: self, customerWorkoutId: customerWorkoutId)
        case .calendar(let customerWorkoutId):
            AmplitudeManager.shared
                .logEvent(name: "Workout Tap", parameters: ["what": "schedule"])
            
            let calendar = CalendarViewController.make(schedulerType: .workout(customerWorkoutId: customerWorkoutId))
            present(calendar, animated: true)
        }
    }
    
    func activity(_ activity: Bool) {
        mainView.tableView.isHidden = activity
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
    
    func assignActivity(_ activity: Bool) {
        activity ? mainView.screenPreloader.startAnimating() : mainView.screenPreloader.stopAnimating()
    }
    
    func open(error: Error) -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make(error: error) {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
}
