//
//  User.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 7/4/2023.
//

import Foundation
struct User: Codable {
    let id: Int
    let username: String
    let first_name: String? // Allow for null values
    let last_name: String?  // Allow for null values
    let email: String
    let onboarding_simple: Bool
    let onboarding_stepper: Bool
    let gender: String?
    let birthday: String?
    let photo: String?
    let created_at: String
    let modified_at: String
    let user_role: String
    let role_data: RoleData // Use the RoleData struct directly
}

struct RoleData: Codable {
    let id: Int
    let enabled: Bool
    let school: String?
}

