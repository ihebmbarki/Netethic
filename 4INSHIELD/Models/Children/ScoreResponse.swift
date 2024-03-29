//
//  ScoreResponse.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 1/6/2023.
//

import Foundation
struct ScoreResponse: Codable {
    let profiles: [Profilee]
    let globalScorePerDate: [Double]
    let globalScore: Double
    
    enum CodingKeys: String, CodingKey {
        case profiles
        case globalScorePerDate = "global_score_per_date"
        case globalScore = "global_score"
    }
}

struct Profilee: Codable {
    let uuid: String
    let score: Double
    let nbData: Double
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case score
        case nbData = "nb_data"
    }
}

struct ScorePlateform: Codable {
    let result: [ResultScore]
}

// MARK: - Result
struct ResultScore: Codable {
    let date: Double
    let maxScorePlatform: String
    let maxScore: Int

    enum CodingKeys: String, CodingKey {
        case date
        case maxScorePlatform = "max_score_platform"
        case maxScore = "max_score"
    }
}
