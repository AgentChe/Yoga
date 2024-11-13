//
//  PaygateViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.09.2022.
//

import UIKit
import RxSwift

final class PaygateViewController: UIViewController {
    weak var delegate: PaygateViewControllerDelegate?
    
    lazy var mainView =  PaygateView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = PaygateViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeManager.shared
            .logEvent(name: "Paygate Screen", parameters: [:])
        
        viewModel.products
            .drive(Binder(self) { base, products in
                base.mainView.leftOptionButton.info = products.first
                base.mainView.rightOptionButton.info = products.last
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                mainView.termsOfServiceButton.rx.tap.map { GlobalDefinitions.termsOfServiceUrl },
                mainView.privacyPolicyButton.rx.tap.map { GlobalDefinitions.privacyPolicyUrl }
            )
            .subscribe(onNext: { url in
                UIApplication.shared.open(url, options: [:])
            })
            .disposed(by: disposeBag)
        
        mainView.restoreButton.rx.tap
            .bind(to: viewModel.restore)
            .disposed(by: disposeBag)
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(with: .cancelled)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .buyed
            .emit(onNext: { [weak self] success in
                if !success {
                    Toast.notify(with: "Paygate.Failed".localized, style: .danger)
                    return
                }
                
                self?.dismiss(with: .bied)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .restored
            .emit(onNext: { [weak self] result in
                if !result {
                    Toast.notify(with: "Paygate.Failed".localized, style: .danger)
                    return
                }
                
                self?.dismiss(with: .restored)
            })
            .disposed(by: disposeBag)
        
        viewModel.activityIndicator
            .drive(Binder(self) { base, active in
                base.activityIndicator(active: active)
            })
            .disposed(by: disposeBag)
        
        mainView.continueButton.rx.tap
            .bind(to: Binder(self) { base, void in
                let id = [
                    base.mainView.leftOptionButton,
                    base.mainView.rightOptionButton
                ].first(where: { $0.isChecked })?.info?.productId
                
                guard let id = id else {
                    return
                }
                
                base.viewModel.buy.accept(id)
            })
            .disposed(by: disposeBag)
        
        mainView.leftOptionButton.isChecked = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

// MARK: Make
extension PaygateViewController {
    static func make() -> PaygateViewController {
        let vc = PaygateViewController()
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension PaygateViewController {
    func dismiss(with result: PaygateViewControllerResult) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.delegate?.paygateDidClosed(with: result)
        }
    }
    
    func activityIndicator(active: Bool) {
        active ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
        
        mainView.leftOptionButton.isHidden = active
        mainView.rightOptionButton.isHidden = active
        mainView.continueButton.isHidden = active
        mainView.restoreButton.isHidden = active
    }
}
