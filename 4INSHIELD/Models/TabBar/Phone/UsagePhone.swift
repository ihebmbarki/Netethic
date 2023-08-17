//
//  UsagePhone.swift
//  4INSHIELD
//
//  Created by kaisensData on 17/8/2023.
//

import Foundation


// MARK: - Phoneuse
struct Phoneuse: Codable {
    let child_id, device_id: String
    let usage_phone_per_day: [UsagePhonePer]
    let limitExcededStatus: LimitExcededStatu
    let average: Double

    enum CodingKeys: String, CodingKey {
        case child_id = "child_id"
        case device_id = "device_id"
        case usage_phone_per_day = "usage_phone_per_day"
        case limitExcededStatus = "limit_exceded_status"
        case average
    }
}

// MARK: - LimitExcededStatus
struct LimitExcededStatu: Codable {
    let value: Double
    let label: String
}

// MARK: - UsagePhonePerDay
struct UsagePhonePer: Codable {
    let timestamp, usage: Int
    let limit_exceeded: Bool
    let hours: Int

    enum CodingKeys: String, CodingKey {
        case timestamp, usage
        case limit_exceeded = "limit_exceeded"
        case hours
    }
}
