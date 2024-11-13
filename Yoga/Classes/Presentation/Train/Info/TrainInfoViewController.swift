//
//  TrainInfoViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 13.03.2023.
//

import UIKit
import RxSwift

final class TrainInfoViewController: UIViewController {
    lazy var mainView = TrainInfoView()

    private lazy var disposeBag = DisposeBag()

    private let didTapContinue: () -> Void

    private init(didTapContinue: @escaping () -> Void) {
        self.didTapContinue = didTapContinue

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
                mainView.continueButton.rx.tap
                    .map { true },
                mainView.cancelButton.rx.tap
                    .map { false }
            )
            .bind(to: Binder(self) { base, continueTapped in
                base.dismiss(continueTapped: continueTapped)
            })
            .disposed(by: disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animateShow()
    }
}

// MARK: Make
extension TrainInfoViewController {
    static func make(didTapContinue: @escaping () -> Void) -> TrainInfoViewController {
        let vc = TrainInfoViewController(didTapContinue: didTapContinue)
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}

// MARK: Private
private extension TrainInfoViewController {
    func animateShow() {
        mainView.containerBottomConstraint.isActive = false
        mainView.containerBottomConstraint.constant = 0
        mainView.containerBottomConstraint.isActive = true

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.mainView.dimmedView.alpha = 0.6
            self?.mainView.layoutIfNeeded()
        })
    }

    func dismiss(continueTapped: Bool) {
        animateDismiss { [weak self] in
            self?.dismiss(animated: false) {
                if continueTapped {
                    self?.didTapContinue()
                }
            }
        }
    }

    func animateDismiss(completion: @escaping (() -> Void)) {
        mainView.containerBottomConstraint.isActive = false
        mainView.containerBottomConstraint.constant = 339.scale
        mainView.containerBottomConstraint.isActive = true

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.mainView.dimmedView.alpha = 0
            self?.mainView.layoutIfNeeded()
        }, completion: { result in
            completion()
        })
    }
}
