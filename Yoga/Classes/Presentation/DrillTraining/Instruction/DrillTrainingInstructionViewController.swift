//
//  DrillTrainingInstructionViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 09.02.2023.
//

import UIKit
import RxSwift

final class DrillTrainingInstructionViewController: UIViewController {
    lazy var mainView = DrillTrainingInstructionView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let viewModel: DrillTrainingInstructionViewModel
    
    private lazy var drillTrainingAssembly = DrillTrainingAssembly()
    
    private init(drill: Drill) {
        viewModel = DrillTrainingInstructionViewModel(source: .drill(drill))
        
        super.init(nibName: nil, bundle: nil)
    }
    
    private init(planDrill: PlanDrill) {
        viewModel = DrillTrainingInstructionViewModel(source: .planDrill(planDrill))
        
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
            .logEvent(name: "Exercise Screen")
        
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
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Make
extension DrillTrainingInstructionViewController {
    static func make(drill: Drill) -> DrillTrainingInstructionViewController {
        let vc = DrillTrainingInstructionViewController(drill: drill)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
    
    static func make(planDrill: PlanDrill) -> DrillTrainingInstructionViewController {
        let vc = DrillTrainingInstructionViewController(planDrill: planDrill)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: DTITableDelegate
extension DrillTrainingInstructionViewController: DTITableDelegate {
    func dtiTableDidTappedCalendar() {
        viewModel.didTapCalendar.accept(())
    }
    
    func dtiTableDidTappedStartTraining() {
        viewModel.didTapStartTraining.accept(Void())
    }
}

// MARK: Private
private extension DrillTrainingInstructionViewController {
    func route(_ route: DrillTrainingInstructionViewModel.Route) {
        switch route {
        case .training(let customerDrillId):
            AmplitudeManager.shared
                .logEvent(name: "Exercise Tap", parameters: ["what": "start"])
            
            drillTrainingAssembly.startTraining(from: self, customerDrillId: customerDrillId)
        case .calendar(let customerDrillId):
            AmplitudeManager.shared
                .logEvent(name: "Exercise Tap", parameters: ["what": "schedule"])
            
            let calendar = CalendarViewController.make(schedulerType: .drill(customerDrillId: customerDrillId))
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
