//
//  ProfileMediator.swift
//  Soccer
//
//  Created by Андрей Чернышев on 03.02.2023.
//

import RxSwift
import RxCocoa

final class ProfileMediator {
    static let shared = ProfileMediator()
    
    private lazy var skillLevelIdChangeTrigger = PublishRelay<Int>()
    private lazy var weekScheduleChangeTrigger = PublishRelay<WeekSchedule>()
    private lazy var drillsIdsChangeTrigger = PublishRelay<[Int]>()
    private lazy var focusZonesIdsChangeTrigger = PublishRelay<[Int]>()
    
    private init() {}
}

// MARK: Public
extension ProfileMediator {
    func notify(skillLevelId: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.skillLevelIdChangeTrigger.accept(skillLevelId)
        }
    }
    
    func notify(weekSchedule: WeekSchedule) {
        DispatchQueue.main.async { [weak self] in
            self?.weekScheduleChangeTrigger.accept(weekSchedule)
        }
    }
    
    func notify(drillsIds: [Int]) {
        DispatchQueue.main.async { [weak self] in
            self?.drillsIdsChangeTrigger.accept(drillsIds)
        }
    }
    
    func notify(focusZonesIds: [Int]) {
        DispatchQueue.main.async { [weak self] in
            self?.focusZonesIdsChangeTrigger.accept(focusZonesIds)
        }
    }
}

// MARK: Public (Rx)
extension ProfileMediator {
    var skillLevelIdChange: Signal<Int> {
        skillLevelIdChangeTrigger.asSignal()
    }
    
    var weekScheduleChange: Signal<WeekSchedule> {
        weekScheduleChangeTrigger.asSignal()
    }
    
    var drillsIdsChange: Signal<[Int]> {
        drillsIdsChangeTrigger.asSignal()
    }
    
    var focusZonesIdsChange: Signal<[Int]> {
        focusZonesIdsChangeTrigger.asSignal()
    }
}
