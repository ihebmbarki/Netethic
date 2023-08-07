//
//  Parent.swift
//  4INSHIELD
//
//  Created by kaisensData on 13/7/2023.
//

import Foundation

struct Parent: Codable {
    let id: Int
    let enabled: Bool
    let school: String?
}

struct Userparent: Codable {
    let id: Int
    let first_name: String?
    let last_name: String?
    let email: String
    let username: String
    let user_agent: String
    let parent: Parent
    let gender: String?
    let birthday: String?
    let photo: String?
}
