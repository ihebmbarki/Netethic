//
//  ChildrenResponse.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 13/7/2023.
//

import Foundation

struct ChildrenResponse: Codable {
    let children: [Childd]

    enum CodingKeys: String, CodingKey {
        case children
    }
}

struct Childd: Codable, Identifiable {
    let id: Int
    let uuid: String?
    let enabled: Bool?
    let street: String?
    let country: String?
    let subclass_school: String?
    let adress: String?
    let user: Userr?
    let parent: String?

    enum CodingKeys: String, CodingKey {
        case id, uuid, enabled, street, country, subclass_school, adress, user, parent
    }
}

struct Userr: Codable {
    let username: String
    let first_name: String
    let last_name: String
    let email: String
    let onboarding_simple: Bool
    let onboarding_stepper: Bool
    let gender: String
    let birthday: String
    let photo: String?
    let created_at: String
    let modified_at: String
    let user_role: String
    let is_active: Bool
}
