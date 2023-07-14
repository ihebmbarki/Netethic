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
    let first_name: String
    let last_name: String?
    let email: String
    let onboarding_simple: Bool
    let onboarding_stepper: Bool
    let gender: String?
    let birthday: String?
    let photo: String?
    let created_at: String
    let modified_at: String
    let user_role: String
    let role_data: RoleData
    
    struct RoleData: Codable {
        let id: Int
        let enabled: Bool
        let school: String?
    }
//
//    init(dictionary: [String: Any]) {
//        self.id = dictionary["id"] as? Int ?? 0
//        self.username = dictionary["username"] as? String ?? ""
//        self.first_name = dictionary["first_name"] as? String ?? ""
//        self.last_name = dictionary["last_name"] as? String
//        self.email = dictionary["email"] as? String ?? ""
//        self.onboarding_simple = dictionary["onboarding_simple"] as? Bool ?? false
//        self.onboarding_stepper = dictionary["onboarding_stepper"] as? Bool ?? false
//        self.gender = dictionary["gender"] as? String
//        self.birthday = dictionary["birthday"] as? String
//        self.photo = dictionary["photo"] as? String
//        self.created_at = dictionary["created_at"] as? String ?? ""
//        self.modified_at = dictionary["modified_at"] as? String ?? ""
//        self.user_role = dictionary["user_role"] as? String ?? ""
//
//        if let roleDataDict = dictionary["role_data"] as? [String: Any] {
//            self.role_data = RoleData(from: roleDataDict as! Decoder)
//        } else {
//            self.role_data = RoleData(id: 0, enabled: false, school: nil)
//        }
//    }
}

