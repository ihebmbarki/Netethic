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
    let email_verification_url: String
    let user_agent = "mobile"
    let password: String
    let birthday: String
    let gender: String
    let enabled = "true"
    let user_type = "parent"


  //  let first_name: String
   // let last_name: String
 //   let confirmPassword: String
   // let user_role = "parent"
}

