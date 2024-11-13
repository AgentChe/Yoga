//
//  TryAgainViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 05.07.2022.
//

import UIKit
import RxSwift

protocol TryAgainViewControllerDelegate: AnyObject {
    func tryAgainDidTapped()
}

final class TryAgainViewController: UIViewController {
    weak var delegate: TryAgainViewControllerDelegate?
    
    lazy var mainView = TryAgainView(error: error)
    
    private lazy var disposeBag = DisposeBag()
    
    private let error: Error
    private let tryAgain: (() -> Void)?
    
    private init(error: Error, tryAgain: (() -> Void)?) {
        self.error = error
        self.tryAgain = tryAgain
        
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
        
        mainView.tryAgainButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.dismiss(animated: true) {
                    self.delegate?.tryAgainDidTapped()
                    self.tryAgain?()
                }
            })
            .disposed(by: disposeBag)
        
        mainView.contactButton.rx.tap
            .subscribe(onNext: {
                UIApplication.shared.open(GlobalDefinitions.contactUsUrl, options: [:])
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension TryAgainViewController {
    static func make(error: Error, tryAgain: (() -> Void)? = nil) -> TryAgainViewController {
        TryAgainViewController(error: error, tryAgain: tryAgain)
    }
}
