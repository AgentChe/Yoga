//
//  DrillTrainingLifeCyrcle.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import Foundation

protocol DrillTrainingLifeCyrcleDelegate: AnyObject {
    func drillTrainingPrepare()
    func drillTrainingReadyIn(seconds: Int)
    func drillTrainingPrepared()
    func drillTrainingDidStart()
    func drillTrainingTick(seconds: Int)
    func drillTrainigPaused()
    func drillTrainingStopped(totalSeconds: Int)
}

final class DrillTrainingLifeCyrcle {
    weak var delegate: DrillTrainingLifeCyrcleDelegate?
    
    private var trainingSeconds = 0
    
    private var timer: Timer?
}

// MARK: Public
extension DrillTrainingLifeCyrcle {
    func startTraining() {
        delegate?.drillTrainingPrepare()
        
        var prepareLeft = 6
        
        delegate?.drillTrainingReadyIn(seconds: prepareLeft - 1)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else {
                return
            }
            
            if prepareLeft > 0 {
                prepareLeft -= 1
                
                if prepareLeft == 1 {
                    self.delegate?.drillTrainingPrepared()
                } else if prepareLeft == 0 {
                    self.delegate?.drillTrainingDidStart()
                } else {
                    self.delegate?.drillTrainingReadyIn(seconds: prepareLeft - 1)
                }
            } else {
                self.trainingSeconds += 1
                
                self.delegate?.drillTrainingTick(seconds: self.trainingSeconds)
            }
        }
    }
    
    func refreshTraining() {
        timer?.invalidate()
        timer = nil
        
        trainingSeconds = 0
        
        startTraining()
    }
    
    func pauseTraining() {
        timer?.invalidate()
        timer = nil
        
        delegate?.drillTrainigPaused()
    }
    
    func continueTraining() {
        delegate?.drillTrainingDidStart()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else {
                return
            }
            
            self.trainingSeconds += 1
            
            self.delegate?.drillTrainingTick(seconds: self.trainingSeconds)
        }
    }
    
    func stopTraining() {
        timer?.invalidate()
        timer = nil
        
        delegate?.drillTrainingStopped(totalSeconds: trainingSeconds)
    }
}
