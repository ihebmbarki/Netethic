//
//  LoginResponse.swift
//  4INSHIELD
//
//  Created by Mohamed Abbes on 6/7/2023.
//

import Foundation
struct LoginResponse: Codable {
    struct Tokens: Codable {
        let accessToken: String
        let refreshToken: String
        let expiresIn: Int
        let tokenType: String
        let idToken: String
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case refreshToken = "refresh_token"
            case expiresIn = "expires_in"
            case tokenType = "token_type"
            case idToken = "id_token"
        }
    }
    
    let tokens: Tokens
    let id: Int
    let username: String
    let email: String
    let onboardingSimple: Bool
    let onboardingStepper: Bool
    
    enum CodingKeys: String, CodingKey {
        case tokens, id, username, email
        case onboardingSimple = "onboarding_simple"
        case onboardingStepper = "onboarding_stepper"
    }
}
