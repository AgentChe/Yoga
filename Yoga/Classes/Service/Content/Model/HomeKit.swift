//
//  HomeKit.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

struct HomeKit: Codable, Hashable {
    let score: Int
    let levelId: Int
    let dailyWorkouts: [WorkoutTemplate]
    let plan: [PlanOnDay]
    let tryDrills: [Drill]
    let trainingCompletedSeconds: Int
}
