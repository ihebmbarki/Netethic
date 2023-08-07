//
//  RegisterModel.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 28/2/2023.
//

import Foundation

struct RegisterModel: Encodable {
    let email: String
    let username: String
    let password: String
    let email_verification_url: String
    let user_agent: String = "mobile"
    let user_role: String = "parent"
}
