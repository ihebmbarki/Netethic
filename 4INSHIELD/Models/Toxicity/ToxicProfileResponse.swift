//
//  ToxicProfileResponse.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 8/6/2023.
//

import Foundation

struct ToxicProfileResponse: Codable {
    let profiles: [ToxicProfile]
}

struct ToxicProfile: Codable {
    let uuid: String
    let toxicRelationships: [ToxicRelationship]
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case toxicRelationships = "toxic_relationships"
    }
}

struct ToxicRelationship: Codable {
    let toxicProfilePseudo: String
    let nbToxicData: Int
    let rate: Double
    
    enum CodingKeys: String, CodingKey {
        case toxicProfilePseudo = "toxic_profile_pseudo"
        case nbToxicData = "nb_toxic_data"
        case rate
    }
}
