//
//  HomeViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import UIKit
import RxSwift

final class HomeViewController: UIViewController {
    lazy var mainView = HomeView()
    
    private lazy var viewModel = HomeViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private let seeAllWorkouts: (() -> Void)
    private let addTrainings: (() -> Void)
    
    private init(seeAllWorkouts: @escaping (() -> Void), addTrainings: @escaping (() -> Void)) {
        self.seeAllWorkouts = seeAllWorkouts
        self.addTrainings = addTrainings
        
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
        
        viewModel.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.mainDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

// MARK: Make
extension HomeViewController {
    static func make(seeAllWorkouts: @escaping (() -> Void), addTrainings: @escaping (() -> Void)) -> HomeViewController {
        let vc = HomeViewController(seeAllWorkouts: seeAllWorkouts, addTrainings: addTrainings)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: HomeTableViewDelegate
extension HomeViewController: HomeTableViewDelegate {
    func homeTableDidTap(drill: Drill) {
        let needPayment = drill.paid ? !SessionManager().hasActiveSubscriptions() : false
        
        if needPayment {
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        } else {
            let vc = DrillTrainingInstructionViewController.make(drill: drill)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func homeTableDidTap(workoutTemplate: WorkoutTemplate) {
        let vc = WorkoutTemplateViewController.make(workoutTemplate: workoutTemplate)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func homeTableDidTap(workoutCover: WorkoutCover) {
        let needPayment = workoutCover.paid ? !SessionManager().hasActiveSubscriptions() : false
        
        if needPayment {
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        } else {
            let vc = WorkoutTemplateViewController.make(workoutCover: workoutCover)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func homeTableDidTap(planDay: Date) {
        viewModel.didTapPlanDay.accept(planDay)
    }
    
    func homeTableDidTap(planDrill: PlanDrill) {
        let vc = DrillTrainingInstructionViewController.make(planDrill: planDrill)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func homeTableDidTap(planWorkout: PlanWorkout) {
        let vc = WorkoutTemplateViewController.make(planWorkout: planWorkout)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func homeTableDidTapAddTraining() {
        addTrainings()
    }
    
    func homeTableDidTap(drillCategory: DrillCategory) {
        let vc = DrillsViewController.make(drillCategory: drillCategory)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func homeTableDidTapTryDrills() {
        let vc = DrillsViewController.make()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func homeTableDidTapWorkouts() {
        seeAllWorkouts()
    }
}

// MARK: Private
private extension HomeViewController {
    func activity(_ activity: Bool) {
        mainView.tableView.isHidden = activity
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
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
