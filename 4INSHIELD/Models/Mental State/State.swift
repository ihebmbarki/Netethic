//
//  State.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 18/5/2023.
//

import Foundation

struct State: Codable {
    let data: [StateData]
    let statistic: Statistic
}

struct StateData: Codable {
    let child_id: String
    let date: Double
    let mental_state: String
}

// MARK: - Statistic
struct Statistic: Codable {
    let happy, stress: Double
}
