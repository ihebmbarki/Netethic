//
//  ToxicPersons.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 5/6/2023.
//

import Foundation

struct ToxicPersons: Codable {
    let toxicRelationships: Int

    private enum CodingKeys: String, CodingKey {
        case toxicRelationships = "toxic-relationships"
    }
}
