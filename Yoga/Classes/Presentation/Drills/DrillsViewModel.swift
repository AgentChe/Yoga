//
//  DrillsViewModel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import RxSwift
import RxCocoa

final class DrillsViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private let drillCategory: Driver<DrillCategory?>
    private lazy var drills = makeDrills()
    private lazy var profile = makeProfile()
    private lazy var skillLevels = makeSkillLevels()
    
    private lazy var drillManager = DrillManager()
    private lazy var profileManager = ProfileManager()
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(drillCategory: DrillCategory?) {
        self.drillCategory = BehaviorRelay(value: drillCategory).asDriver()
    }
}

// MARK: Private
private extension DrillsViewModel {
    func makeElements() -> Driver<[HomeTableElement]> {
        Driver
            .combineLatest(drills, skillLevels)
            .map { drills, skillLevels -> [HomeTableElement] in
                var result = [HomeTableElement]()
                
                drills.enumerated().forEach { index, drill in
                    guard let skillLevel = skillLevels.first(where: { $0.id == drill.skillLevelId }) else {
                        return
                    }
                    
                    let element = HomeDrillElement(
                        drill: drill,
                        skillLevel: skillLevel
                    )
                    result.append(.drill(element))
                    
                    if index != (drills.count - 1) {
                        result.append(.offset(16.scale))
                    }
                }
                
                return result
            }
    }
    
    func makeDrills() -> Driver<[Drill]> {
        Driver
            .combineLatest(drillCategory, profile)
            .flatMapLatest { [weak self] drillCategory, profile -> Driver<[Drill]> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<[Drill]> {
                    self.drillManager
                        .obtainDrills(categoryId: drillCategory?.id,
                                      levelId: profile?.skillLevelId)
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
                    .trackActivity(self.activity)
                    .asDriver(onErrorJustReturn: [])
            }
    }
    
    func makeProfile() -> Driver<Profile?> {
        profileManager
            .obtainProfile(forceUpdate: false)
            .asDriver(onErrorJustReturn: nil)
    }
    
    func makeSkillLevels() -> Driver<[SkillLevel]> {
        contentManager
            .obtainLevels(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
}
