//
//  UserProfileResponse.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 5/6/2023.
//

import Foundation

struct UserProfileResponse: Codable {
    let profileImage: String
    
    enum CodingKeys: String, CodingKey {
        case profileImage = ""
    }
}
