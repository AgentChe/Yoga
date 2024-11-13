//
//  OCombineData.swift
//  Wicca
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import Foundation

struct OCombineData {
    let skillLevel: SkillLevel
    let weekSchedule: WeekSchedule
    let drillCategories: [Int]
    let focusZones: [FocusZone]
    let gender: Gender
}

final class OnboardingCombineData {
    private var skillLevel: SkillLevel?
    private var weekSchedule: WeekSchedule?
    private var drillCategories: [DrillCategory]?
    private var focusZones: [FocusZone]?
    private var gender: Gender?
    
    func combineData() -> OCombineData? {
        guard
            let skillLevel = skillLevel,
            let weekSchedule = weekSchedule,
            let drillCategories = drillCategories,
            let focusZones = focusZones,
            let gender = gender
        else {
            return nil
        }

        return OCombineData(
            skillLevel: skillLevel,
            weekSchedule: weekSchedule,
            drillCategories: drillCategories.map { $0.id },
            focusZones: focusZones,
            gender: gender
        )
    }
}

// MARK: OSkillLevelViewDelegate
extension OnboardingCombineData: OSkillLevelViewDelegate {
    func skillLevelViewDidSelect(skillLevel: SkillLevel) {
        self.skillLevel = skillLevel
    }
}

// MARK: ODaysOfWeekViewDelegate
extension OnboardingCombineData: ODaysOfWeekViewDelegate {
    func daysOfWeekViewDidSelect(weekSchedule: WeekSchedule) {
        self.weekSchedule = weekSchedule
    }
}

// MARK: ODrillsViewDelegate
extension OnboardingCombineData: ODrillsViewDelegate {
    func drillsViewDidSelect(drillCategories: [DrillCategory]) {
        self.drillCategories = drillCategories
    }
}

// MARK: OFocusZoneViewDelegate
extension OnboardingCombineData: OFocusZoneViewDelegate {
    func focusZoneDidSelect(focusZones: [FocusZone]) {
        self.focusZones = focusZones
    }
}

// MARK: OGenderViewDelegate
extension OnboardingCombineData: OGenderViewDelegate {
    func genderViewDidSelect(gender: Gender) {
        self.gender = gender
    }
}
