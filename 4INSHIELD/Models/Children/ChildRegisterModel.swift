//
//  ChildRegisterModel.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 18/7/2023.
//

import Foundation

class ChildRegisterModel: Encodable {
    var first_name: String
    var last_name: String
    var gender: String
    let email: String
    let username: String
    let password: String
    let email_verification_url: String
    let user_agent: String
    var enabled: Bool
    var street: String
    var country: Int
    var birthday: String
    let user_type: String
    
    init(email: String, username: String, password: String, email_verification_url: String) {
        self.email = email
        self.username = username
        self.password = password
        self.email_verification_url = email_verification_url
        self.first_name = ""
        self.last_name = ""
        self.gender = ""
        self.user_agent = "mobile"
        self.enabled = true
        self.street = ""
        self.country = 0
        self.birthday = ""
        self.user_type = "child"
    }
}
