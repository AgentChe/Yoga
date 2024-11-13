//
//  DrillTrainingPlayPauseButton.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import UIKit

final class DrillTrainingPlayPauseButton: TapAreaButton {
    enum State {
        case play, pause
    }
    
    var stateCode = State.pause {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func invertedState() {
        switch stateCode {
        case .play:
            stateCode = .pause
        case .pause:
            stateCode = .play
        }
    }
}

// MARK: Private
private extension DrillTrainingPlayPauseButton {
    func update() {
        switch stateCode {
        case .play:
            setImage(UIImage(named: "DrillTraining.Pause"), for: .normal)
        case .pause:
            setImage(UIImage(named: "DrillTraining.Play"), for: .normal)
        }
    }
}
