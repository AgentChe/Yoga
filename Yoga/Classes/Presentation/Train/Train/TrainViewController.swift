//
//  TrainViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 13.03.2023.
//

import UIKit
import RxSwift
import RxRelay

final class TrainViewController: UIViewController {
    lazy var mainView = TrainView()
    
    private lazy var viewModel = TrainViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private let didOpenProfile: (() -> Void)
    
    private init(didOpenProfile: @escaping () -> Void) {
        self.didOpenProfile = didOpenProfile
        
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
            .logEvent(name: "Train Screen")
        
        mainView.infoButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.didTapInfo()
            })
            .disposed(by: disposeBag)
        
        viewModel.sections
            .drive(Binder(mainView.tableView) { base, sections in
                base.setup(sections: sections)
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

// MARK: Public
extension TrainViewController {
    static func make(didOpenProfile: @escaping () -> Void) -> TrainViewController {
        let vc = TrainViewController(didOpenProfile: didOpenProfile)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: TrainTableDelegate
extension TrainViewController: TrainTableDelegate {
    func trainTableDidTapped(training: TrainTrainigElement.Training) {
        switch training {
        case .workoutCover(let workoutCover):
            let needPayment = workoutCover.paid ? !SessionManager().hasActiveSubscriptions() : false
            
            if needPayment {
                let vc = PaygateViewController.make()
                present(vc, animated: true)
            } else {
                let vc = WorkoutTemplateViewController.make(workoutCover: workoutCover)
                navigationController?.pushViewController(vc, animated: true)
            }
        case .focusZone(let focusZone):
            let needPayment = focusZone.paid ? !SessionManager().hasActiveSubscriptions() : false
            
            if needPayment {
                let vc = PaygateViewController.make()
                present(vc, animated: true)
            } else {
                let vc = WorkoutTemplateViewController.make(focusZone: focusZone)
                navigationController?.pushViewController(vc, animated: true)
            }
        case .workoutStep(let workoutStep):
            let needPayment = workoutStep.paid ? !SessionManager().hasActiveSubscriptions() : false
            
            if needPayment {
                let vc = PaygateViewController.make()
                present(vc, animated: true)
            } else {
                let vc = WorkoutTemplateViewController.make(workoutStep: workoutStep)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

// MARK: Private
private extension TrainViewController {
    func didTapInfo() {
        let vc = TrainInfoViewController.make { [weak self] in
            self?.didOpenProfile()
        }
        present(vc, animated: false)
    }
}
