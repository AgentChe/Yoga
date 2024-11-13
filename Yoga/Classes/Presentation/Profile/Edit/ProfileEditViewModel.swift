//
//  ProfileEditViewModel.swift
//  Soccer
//
//  Created by Виталий Загороднов on 30.04.2023.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileEditViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var saveResult = makeSaveResult()
    
    lazy var skillLevelRelay = PublishRelay<SkillLevel>()
    lazy var weekScheduleRelay = PublishRelay<WeekSchedule>()
    lazy var focusZonesRelay = PublishRelay<[FocusZone]>()
    lazy var goalsRelay = PublishRelay<[DrillCategory]>()
    
    lazy var activity = RxActivityIndicator()
    
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension ProfileEditViewModel {
    func makeSaveResult() -> Signal<Void> {
        let skillLevel = skillLevelRelay
            .flatMapLatest { [weak self] skillLevel -> Observable<Void> in
                guard let self else { return .never() }
                
                func source() -> Single<Void> {
                    self.profileManager.set(skillLevelId: skillLevel.id)
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(
                        source: source,
                        trigger: trigger
                    )
                    .trackActivity(self.activity)
            }
        
        let weekSchedule = weekScheduleRelay
            .flatMapLatest { [weak self] weekSchedule -> Observable<Void> in
                guard let self else { return .never() }
                
                func source() -> Single<Void> {
                    self.profileManager.set(weekSchedule: weekSchedule)
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(
                        source: source,
                        trigger: trigger
                    )
                    .trackActivity(self.activity)
            }
        
        let focusZones = focusZonesRelay
            .flatMapLatest { [weak self] focusZones -> Observable<Void> in
                guard let self else { return .never() }
                
                func source() -> Single<Void> {
                    self.profileManager.set(focusZonesIds: focusZones.map { $0.id })
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
               return self.observableRetrySingle
                    .retry(
                        source: source,
                        trigger: trigger
                    )
                    .trackActivity(self.activity)
            }
        
        let goals = goalsRelay
            .flatMapLatest { [weak self] goals -> Observable<Void> in
                guard let self else { return .never() }
                
                func source() -> Single<Void> {
                    self.profileManager.set(drillsIds: goals.map { $0.id })
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
               return self.observableRetrySingle
                    .retry(
                        source: source,
                        trigger: trigger
                    )
                    .trackActivity(self.activity)
            }
        
        return Observable
            .merge(skillLevel, weekSchedule, focusZones, goals)
            .asSignal(onErrorSignalWith: .never())
    }
}
