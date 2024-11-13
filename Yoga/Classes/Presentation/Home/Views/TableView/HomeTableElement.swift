//
//  HomeTableElement.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import UIKit

enum HomeTableElement {
    case offset(CGFloat)
    case title(HomeTitleElement)
    case stats(HomeStatsElement)
    case dailyPicks([DailyPicksElement])
    case plan([PlanWeekDayButton.Model])
    case planTraining(HomePlanTrainingElement)
    case noTrainings
    case addTraining
    case drillCategories([DrillCategory])
    case tryDrillsTitle(String)
    case drill(HomeDrillElement)
    case workoutsTitle(String)
    case workouts([HomeWorkoutElement])
}

enum HomeTitleElement {
    case large(String)
    case small(String)
}

struct HomeStatsElement {
    let score: Int
    let skillLevel: SkillLevel
}

struct DailyPicksElement {
    enum DailyPicks {
        case drill(Drill)
        case workout(WorkoutTemplate)
    }
    
    let dailyPicks: DailyPicks
    let image: URL
    let name: String
    let tag1: String
    let tag2: String?
    let action: String
    
    init(drill: Drill, skillLevel: SkillLevel, drillCategory: DrillCategory) {
        dailyPicks = .drill(drill)
        image = drill.image
        name = drill.name
        tag1 = skillLevel.name
        tag2 = drillCategory.name
        action = "Home.StartTraining".localized
    }
    
    init(workout: WorkoutTemplate, skillLevel: SkillLevel) {
        dailyPicks = .workout(workout)
        image = workout.image
        name = workout.name
        tag1 = skillLevel.name
        tag2 = String(format: "Home.ExercisesCount".localized, workout.exercises.count)
        action = "Home.StartTraining".localized
    }
}

struct HomePlanTrainingElement {
    enum Training {
        case drill(PlanDrill)
        case workout(PlanWorkout)
    }
    
    let training: Training
    let skillLevel: SkillLevel
}

struct HomeDrillElement {
    let drill: Drill
    let skillLevel: SkillLevel
}

struct HomeWorkoutElement {
    let workout: WorkoutCover
    let skillLevel: SkillLevel
}
