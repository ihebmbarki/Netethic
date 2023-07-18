//
//  ChildModel.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 27/3/2023.
//

struct ChildModel: Encodable {
    let first_name: String
    let last_name: String
    let birthday: String
    let email: String
    let gender: String
    let parent_id: Int
    
    enum CodingKeys: String, CodingKey {
        case first_name
        case last_name
        case birthday
        case email
        case gender
        case parent_id
    }
}
