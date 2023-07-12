//
//  ChildModel.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 27/3/2023.
//

import Foundation

struct ChildModel: Encodable {
    let parent_id: Int
    let first_name: String
    let last_name: String
    let birthday: String
}
