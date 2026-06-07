//
//  SplashReceiptValidationObserver.swift
//  Soccer
//
//  Created by Андрей Чернышев on 05.07.2022.
//

import OtterScaleiOS

final class SplashReceiptValidationObserver {
    private var completion: (() -> Void)?
    
    private lazy var defaultValidationObserver = DefaultValidationObserver { [weak self] in
        guard let self = self else { return }
        
        self.completion?()
    }
    
    func observe(completion: @escaping () -> Void) {
        self.completion = completion
        
        defaultValidationObserver.observe()
    }
}

// MARK: Private(DefaultValidationObserver)
private final class DefaultValidationObserver: OtterScaleReceiptValidationDelegate {
    private let completion: (() -> Void)
    
    init(completion: @escaping (() -> Void)) {
        self.completion = completion
    }
    
    func observe() {
        OtterScale.shared.addReceiptValidation(delegate: self)
    }
    
    func otterScaleDidValidatedReceipt(with result: AppStoreValidateResult?) {
        OtterScale.shared.removeReceiptValidation(delegate: self)
        
        completion()
    }
}
