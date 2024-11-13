//
//  OSlideView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit

protocol OSlideViewDelegate: AnyObject {
    func slideViewDidNext(from step: OnboardingView.Step)
    func slideViewDidBack(from step: OnboardingView.Step)
}

class OSlideView: UIView {
    let step: OnboardingView.Step
    
    weak var delegate: OSlideViewDelegate?
    
    init(step: OnboardingView.Step) {
        self.step = step
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveToThis() {}
    
    @objc
    func onNext() {
        delegate?.slideViewDidNext(from: step)
    }
    
    @objc
    func onBack() {
        delegate?.slideViewDidBack(from: step)
    }
}
