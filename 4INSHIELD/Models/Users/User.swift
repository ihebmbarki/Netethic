//
//  User.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 7/4/2023.
//

import Foundation

struct User: Codable {
    let username: String
    let first_name: String?
    let last_name: String?
    let email: String
    let gender: String?
    let birthday: String?
    let photo: String?
    let created_at: String
    let modified_at: String
    let url: String
    
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.first_name = dictionary["first_name"] as? String ?? ""
        self.last_name = dictionary["last_name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.gender = dictionary["gender"] as? String ?? "M"
        self.birthday = dictionary["birthday"] as? String ?? "1990-04-04"
        self.created_at = dictionary["created_at"] as? String ?? "1990-04-04"
        self.modified_at = dictionary["modified_at"] as? String ?? "1990-04-04"
        self.url = dictionary["url"] as? String ?? ""
            self.photo = dictionary["photo"] as? String ?? ""
    }
    
}
