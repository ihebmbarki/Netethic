//
//  Platform.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 29/5/2023.
//

import Foundation

struct Platform: Codable {
    let platforms: [PlatformDetail]
}

struct PlatformDetail: Codable {
    let platform: String
    let logo: URL
}
