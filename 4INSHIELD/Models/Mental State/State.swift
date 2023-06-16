//
//  State.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 18/5/2023.
//

import Foundation

struct State: Codable {
    let data: [StateData]
    let statistic: [String: Double]
}

struct StateData: Codable {
    let child_id: String
    let date: TimeInterval
    let mental_state: String
}
