//
//  CaloriesCalculator.swift
//  Mr-Ride-iOS
//
//  Created by Chang-Ching CHEN on 6/17/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import Foundation

class CaloriesCalculator {
    
    private let kCalBurnedPerUnit = [
        ExerciseType.Bike : 0.4
    ]
    
    enum ExerciseType {
        case Bike
    }
    
    func calculateKCalBurned(exerciseType: ExerciseType, speed: Double, weight: Double, time: Double) -> Double {
        if let kCalBurnedPerUnit = kCalBurnedPerUnit[exerciseType] {
            return kCalBurnedPerUnit * speed * weight * time
        } else {
            return 0.0
        }
    }
}