//
//  ProfileDetailsViewModel.swift
//  Soccer
//
//  Created by Виталий Загороднов on 25.04.2023.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileDetailsViewModel {
    enum Route {
        case skillLevel(SkillLevel?)
        case trainingDays(WeekSchedule?)
        case focusZone([FocusZone], Gender?)
        case goals([DrillCategory])
        case open(url: URL)
    }
    
    lazy var selectedCellModel = PublishRelay<ProfileDetailsTableElement>()
    
    lazy var elements = makeElements()
    lazy var route = makeRoute()
    
    private lazy var editableData = makeEditableData()
    
    private lazy var profileManager = ProfileManager()
    private lazy var contentManager = ContentManager()
    private lazy var workoutManager = WorkoutManager()
    private lazy var drillManager = DrillManager()
}

private extension ProfileDetailsViewModel {
    func makeRoute() -> Signal<Route> {
        selectedCellModel
            .withLatestFrom(editableData.asObservable()) { ($0, $1) }
            .compactMap { item, data -> Route? in
                guard case let .item(cellType, _, _) = item else { return nil }
                
                switch cellType {
                case .skillLevel:
                    return .skillLevel(data.level)
                case .trainingDays:
                    return .trainingDays(data.weekSchedule)
                case .focusZone:
                    return .focusZone(data.zones, data.gender)
                case .goals:
                    return .goals(data.goals)
                case .termsOfUse:
                    return .open(url: GlobalDefinitions.termsOfServiceUrl)
                case .privatePolicy:
                    return .open(url: GlobalDefinitions.privacyPolicyUrl)
                case .contactUs:
                    return .open(url: GlobalDefinitions.contactUsUrl)
                }
            }
            .asSignal(onErrorSignalWith: .never())
    }
    
    func makeEditableData() -> Driver<EditableData> {
        let profile = profileManager.obtainProfile(forceUpdate: false)
            .compactMap { $0 }
            .asObservable()
            .share(replay: 1)
        
        let currentLevel = Observable
            .merge(
                ProfileMediator.shared.skillLevelIdChange.map { $0 }.asObservable(),
                profile.map { $0.skillLevelId }
            )
        
        let level = Observable
            .combineLatest(
                contentManager.obtainLevels(forceUpdate: false).asObservable(),
                currentLevel
            ) { levels, currentId in
                levels.first(where: { $0.id == currentId })
            }
        
        let weekSchedule = Observable<WeekSchedule?>
            .merge(
                profile.map { $0.weekSchedule },
                ProfileMediator.shared.weekScheduleChange.map { $0 }.asObservable()
            )
        
        let currentFocusZonesIds = Observable
            .merge(
                profile.map { $0.focusZonesIds ?? [] },
                ProfileMediator.shared.focusZonesIdsChange.asObservable()
            )
        
        let focusZones = Observable
            .combineLatest(
                workoutManager.obtainFocusZones(forceUpdate: false).asObservable(),
                currentFocusZonesIds
            ) { focusZones, focusZonesIds in
                focusZonesIds
                    .compactMap { id in
                        focusZones.first(where: { $0.id == id })
                    }
            }
        
        let currentGoals = Observable
            .merge(
                profile.map { $0.drillsIds ?? [] },
                ProfileMediator.shared.drillsIdsChange.asObservable()
            )
        
        let goals = Observable
            .combineLatest(
                drillManager.obtainDrillCategories(forceUpdate: false).asObservable(),
                currentGoals
            ) { drills, ids in
                ids.compactMap { id in
                    drills.first(where: { $0.id == id })
                }
            }
        
        return Observable
            .combineLatest(level, weekSchedule, focusZones, profile.map { $0.gender }, goals) {
                EditableData(level: $0, weekSchedule: $1, zones: $2, gender: $3, goals: $4)
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeElements() -> Driver<[ProfileDetailsTableElement]> {
        editableData
            .map { value -> [ProfileDetailsTableElement] in
                let trainingDaysSubtitle = value.weekSchedule?.daysString
                let focusZonesSubtitle = value.zones.map { $0.name }.joined(separator: ", ")
                let goalsSubtitle = value.goals.map { $0.name }.joined(separator: ", ")
                
                return [
                    .item(type: .skillLevel, subtitle: value.level?.name),
                    .item(type: .trainingDays, subtitle: trainingDaysSubtitle),
                    .item(type: .focusZone, subtitle: focusZonesSubtitle),
                    .item(type: .goals, isLast: true, subtitle: goalsSubtitle),
                    .header("Profile.Legal&Privacy".localized),
                    .item(type: .termsOfUse),
                    .item(type: .privatePolicy),
                    .item(type: .contactUs, isLast: true)
                ]
            }
            .asDriver(onErrorJustReturn: [])
    }
}

private extension ProfileDetailsViewModel {
    struct EditableData {
        let level: SkillLevel?
        let weekSchedule: WeekSchedule?
        let zones: [FocusZone]
        let gender: Gender?
        let goals: [DrillCategory]
    }
}

private extension WeekSchedule {
    var daysString: String {
        [
            su ? "Onboarding.DaysOfWeek.Su".localized : nil,
            mo ? "Onboarding.DaysOfWeek.Mo".localized : nil,
            tu ? "Onboarding.DaysOfWeek.Tu".localized : nil,
            we ? "Onboarding.DaysOfWeek.We".localized : nil,
            th ? "Onboarding.DaysOfWeek.Th".localized : nil,
            fr ? "Onboarding.DaysOfWeek.Fr".localized : nil,
            sa ? "Onboarding.DaysOfWeek.Sa".localized : nil
        ]
        .compactMap { $0 }
        .joined(separator: ", ")
    }
}
