//
//  LoginModel.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 3/3/2023.
//

import Foundation


struct LoginModel: Encodable {
    let username: String
    let password: String
    let onboarding_simple: Bool
//    let client_id = Constant
    let client_id = BuildConfiguration.shared.CLIENT_ID
//    let client_secret = "fb606ceb76d93b2656b7a734f2ff8538c003e6f01f200a6650fd1a63"
    let client_secret = BuildConfiguration.shared.CLIENT_SECRET

}
