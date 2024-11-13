//
//  ProfileMainViewController.swift
//  Soccer
//
//  Created by Виталий Загороднов on 25.04.2023.
//

import UIKit
import RxSwift

class ProfileMainViewController: UIViewController {
    
    lazy var mainView = ProfileMainView()
    
    private let viewModel: ProfileMainViewModel = .init()
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeManager.shared
            .logEvent(name: "Profile Screen")
        
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
            .drive(with: mainView.tableView) { $0.setup(elements: $1) }
            .disposed(by: disposeBag)
        
        viewModel.route
            .emit(with: self) { $0.route($1) }
            .disposed(by: disposeBag)
        
        mainView.tableView.didSelectCell
            .bind(to: viewModel.didSelectCell)
            .disposed(by: disposeBag)
        
        mainView.tableView.didSelectDay
            .bind(to: viewModel.didTapPlanDay)
            .disposed(by: disposeBag)
    }
    
}

extension ProfileMainViewController {
    static func make() -> ProfileMainViewController {
        let vc = ProfileMainViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension ProfileMainViewController {
    func route(_ route: ProfileMainViewModel.Route) {
        switch route {
        case .details:
            AmplitudeManager.shared
                .logEvent(name: "Profile Tap", parameters: ["what": "my profile"])
            
            let vc = ProfileDetailsViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .drill(let drill):
            let vc = DrillTrainingInstructionViewController.make(planDrill: drill)
            navigationController?.pushViewController(vc, animated: true)
        case .workout(let workout):
            let vc = WorkoutTemplateViewController.make(planWorkout: workout)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func activity(_ activity: Bool) {
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
