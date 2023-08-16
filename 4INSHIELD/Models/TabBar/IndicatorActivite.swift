//
//  IndicatorActivite.swift
//  4INSHIELD
//
//  Created by kaisensData on 16/8/2023.
//

import Foundation

struct IndicatorActiviteElement: Codable {
    let labels: [String]
    let nameFr, nameEn: String
    let toxicityRate: Double
    let icon: String

    enum CodingKeys: String, CodingKey {
        case labels
        case nameFr = "name-fr"
        case nameEn = "name-en"
        case toxicityRate = "toxicity_rate"
        case icon
    }
}
