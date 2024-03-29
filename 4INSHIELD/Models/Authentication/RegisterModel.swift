//
//  RegisterModel.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 28/2/2023.
//

import Foundation

struct RegisterModel: Encodable {
    let username: String
    let email: String
//    let email_verification_url: String
    let password: String
    let user_agent = "mobile"
    let user_type = "parent"
}
