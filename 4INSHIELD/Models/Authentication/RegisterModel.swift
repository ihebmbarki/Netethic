//
//  RegisterModel.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 28/2/2023.
//

import Foundation

struct RegisterModel: Encodable {
    let username: String
    let first_name: String
    let last_name: String
    let email: String
    let password: String
 //   let confirmPassword: String
    let birthday = "2002-09-22"
    let user_agent = "mobile"
    let user_role = "parent"
    let user_type = "parent"
}
