//
//  UserNameChildResponseModel.swift
//  4INSHIELD
//
//  Created by kaisensData on 18/7/2023.
//

import Foundation

// MARK: - UserNameChildResponseModelElement
    struct UserNameChildResponseModelElement: Codable {
        let username: String
        let first_name: String
        let last_name: String
        let email: String
        let onboarding_simple: Bool
        let onboarding_stepper: Bool
        let gender: String
        let birthday: String
        let photo: String
        let created_at: String
        let modified_at: String
        let user_role: String
        let is_active: Bool
    }

    struct ChildResponseModelElement: Codable {
        let id: Int
        let uuid: String
        let enabled: Bool
        let street: String?
        let country: String?
        let subclass_school: String?
        let adress: String?
        let user: UserNameChildResponseModelElement
        let parent: String? // Remplacez le type de données par le modèle Parent si nécessaire
    }
