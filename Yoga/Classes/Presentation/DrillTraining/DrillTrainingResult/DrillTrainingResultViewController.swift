//
//  DrillTrainingResultViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.03.2023.
//

import UIKit
import RxSwift

final class DrillTrainingResultViewController: UIViewController {
    lazy var mainView = DrillTrainingResultView(drillTraining: drillTraining)
    
    private lazy var viewModel = DrillTrainingResultViewModel(drillTraining: drillTraining)
    
    private lazy var disposeBag = DisposeBag()
    
    private let drillTraining: DrillTraining
    
    private init(drillTraining: DrillTraining) {
        self.drillTraining = drillTraining
        
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
extension DrillTrainingResultViewController {
    static func make(drillTraining: DrillTraining) -> DrillTrainingResultViewController {
        let vc = DrillTrainingResultViewController(drillTraining: drillTraining)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}
