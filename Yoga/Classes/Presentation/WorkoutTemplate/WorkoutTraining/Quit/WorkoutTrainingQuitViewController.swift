//
//  WorkoutTrainingQuitViewController.swift
//  Soccer
//
//  Created by Виталий Загороднов on 13.04.2023.
//

import UIKit
import RxSwift

class WorkoutTrainingQuitViewController: UIViewController {
    lazy var mainView = WorkoutTrainingQuitView()

    private lazy var disposeBag = DisposeBag()

    private let completion: (Bool) -> Void

    private init(completion: @escaping (Bool) -> Void) {
        self.completion = completion

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
                mainView.continueButton.rx.tap.map { false },
                mainView.finishButton.rx.tap.map { true }
            )
            .bind(to: Binder(self) { base, finish in
                base.dismiss(finish: finish)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animateShow()
    }
}

// MARK: Make
extension WorkoutTrainingQuitViewController {
    static func make(completion: @escaping (Bool) -> Void) -> WorkoutTrainingQuitViewController {
        let vc = WorkoutTrainingQuitViewController(completion: completion)
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}

// MARK: Private
private extension WorkoutTrainingQuitViewController {
    func animateShow() {
        mainView.containerBottomConstraint.isActive = false
        mainView.containerBottomConstraint.constant = 0
        mainView.containerBottomConstraint.isActive = true

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.mainView.dimmedView.alpha = 0.6
            self?.mainView.layoutIfNeeded()
        })
    }

    func dismiss(finish: Bool) {
        animateDismiss { [weak self] in
            self?.dismiss(animated: false) {
                self?.completion(finish)
            }
        }
    }
    
    func animateDismiss(completion: @escaping (() -> Void)) {
        mainView.containerBottomConstraint.isActive = false
        mainView.containerBottomConstraint.constant = 304.scale
        mainView.containerBottomConstraint.isActive = true

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.mainView.dimmedView.alpha = 0
            self?.mainView.layoutIfNeeded()
        }, completion: { result in
            completion()
        })
    }
}
