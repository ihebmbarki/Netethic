//
//  ChildModel.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 27/3/2023.
//

import Foundation

struct ChildModel: Encodable, Identifiable {
    let id: Int
    let parent: Int
    let first_name: String
    let last_name: String
    let birthday: String
    let gender: String
    let meta: String?
    let photo: String?
    let created_at: String
    let modified_at: String
    let url: String
    let issync: Bool
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.parent = dictionary["parent"] as? Int ?? 0
        self.first_name = dictionary["first_name"] as? String ?? "test"
        self.last_name = dictionary["last_name"] as? String ?? "test"
        self.gender = dictionary["gender"] as? String ?? "M"
        self.birthday = dictionary["birthday"] as? String ?? "1990-04-04"
        self.created_at = dictionary["created_at"] as? String ?? "1990-04-04"
        self.modified_at = dictionary["modified_at"] as? String ?? "1990-04-04"
        self.url = dictionary["url"] as? String ?? ""
        self.issync = dictionary["issync"] as? Bool ?? false
        self.meta = dictionary["meta"] as? String ?? ""
        self.photo = dictionary["photo"] as? String ?? ""
    }
}
