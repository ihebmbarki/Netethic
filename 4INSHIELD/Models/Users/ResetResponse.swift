//
//  ResetResponse.swift
//  4INSHIELD
//
//  Created by Mohamed Abbes on 7/7/2023.
//

import Foundation
struct UserResponse: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let email: String
    let onboardingSimple: Bool
    let onboardingStepper: Bool
    let gender: String
    let birthday: String?
    let photo: String?
    let createdAt: String
    let modifiedAt: String
    let url: String
    let userRole: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case onboardingSimple = "onboarding_simple"
        case onboardingStepper = "onboarding_stepper"
        case gender
        case birthday
        case photo
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
        case url
        case userRole = "user_role"
    }
}
struct GenerateOTPResponse: Codable {
    let success: String
    let token: String
}
