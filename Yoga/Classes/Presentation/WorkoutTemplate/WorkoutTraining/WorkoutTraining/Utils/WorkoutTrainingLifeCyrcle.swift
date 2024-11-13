//
//  WorkoutTrainingLifeCyrcle.swift
//  Soccer
//
//  Created by Виталий Загороднов on 25.03.2023.
//

import Foundation

protocol WorkoutTrainingLifeCyrcleDelegate: AnyObject {
    func workoutTrainingPrepare()
    func workoutTrainingReadyIn(seconds: Int)
    func workoutTrainingPrepared()
    func workoutTrainingDidStart()
    func workoutTrainingTick(seconds: Int)
    func workoutTrainigPaused()
    func workoutTrainingStopped(totalSeconds: Int, exersiseId: Int)
    func workoutTrainingFinish(totalSeconds: Int, exersiseId: Int)
    func workoutTrainingStartStep()
}

final class WorkoutTrainingLifeCyrcle {
    weak var delegate: WorkoutTrainingLifeCyrcleDelegate?
    
    private var trainingSeconds = 0
    
    private var timer: Timer?
    private var trainingTimer: Timer?
}

// MARK: Public
extension WorkoutTrainingLifeCyrcle {
    func start() {
        delegate?.workoutTrainingPrepare()
        timer?.invalidate()
        timer = nil
        
        var prepareLeft = 6
        
        delegate?.workoutTrainingReadyIn(seconds: prepareLeft - 1)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else {
                return
            }
            
            if prepareLeft > 0 {
                prepareLeft -= 1
                
                switch prepareLeft {
                case 0:
                    self.delegate?.workoutTrainingDidStart()
                    self.delegate?.workoutTrainingStartStep()
                case 1:
                    self.delegate?.workoutTrainingPrepared()
                default:
                    self.delegate?.workoutTrainingReadyIn(seconds: prepareLeft - 1)
                }
            }
        }
    }
    
    func startTrainig() {
        trainingTimer?.invalidate()
        trainingTimer = nil
        trainingSeconds = 0
        delegate?.workoutTrainingTick(seconds: trainingSeconds)
        
        trainingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else {
                return
            }
            
            self.trainingSeconds += 1
            self.delegate?.workoutTrainingTick(seconds: self.trainingSeconds)
        }
    }
    
    func pauseTraining() {
        trainingTimer?.invalidate()
        trainingTimer = nil
        
        delegate?.workoutTrainigPaused()
    }
    
    func continueTraining() {
        delegate?.workoutTrainingDidStart()
        
        trainingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else {
                return
            }
            
            self.trainingSeconds += 1
            
            self.delegate?.workoutTrainingTick(seconds: self.trainingSeconds)
        }
    }
    
    func stopTraining(exersiseId: Int) {
        trainingTimer?.invalidate()
        trainingTimer = nil
        
        delegate?.workoutTrainingStopped(totalSeconds: trainingSeconds, exersiseId: exersiseId)
    }
    
    func finishWorkout(exersiseId: Int) {
        trainingTimer?.invalidate()
        trainingTimer = nil
        
        delegate?.workoutTrainingFinish(totalSeconds: trainingSeconds, exersiseId: exersiseId)
    }
}
