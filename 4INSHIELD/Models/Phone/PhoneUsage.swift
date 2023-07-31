//
//  PhoneUsage.swift
//  4INSHIELD
//
//  Created by kaisensData on 31/7/2023.
//

import Foundation

struct PhoneUsage: Codable {
    let childID, deviceID: String
    let usagePhonePerDay: [UsagePhonePerDay]
    let limitExcededStatus: LimitExcededStatus
    let average: Double

    enum CodingKeys: String, CodingKey {
        case childID = "child_id"
        case deviceID = "device_id"
        case usagePhonePerDay = "usage_phone_per_day"
        case limitExcededStatus = "limit_exceded_status"
        case average
    }
}

struct LimitExcededStatus: Codable {
    let value: Double
    let label: String
}

struct UsagePhonePerDay: Codable {
    let timestamp, usage: Int
    let limitExceeded: Bool
    let hours: Int

    enum CodingKeys: String, CodingKey {
        case timestamp, usage
        case limitExceeded = "limit_exceeded"
        case hours
    }
}
