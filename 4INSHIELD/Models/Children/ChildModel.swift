//
//  ChildModel.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 27/3/2023.
//

struct ChildModel: Codable {
    let first_name: String
    let last_name: String
    let birthday: String
    let email: String
    let gender: String
    let parent_id: Int
    
}

struct UserRole: Codable {
    let id: Int
    let username, email, firstName, lastName: String
    let birthday: String
    let age: Int
    let gender: String
    let child: ChildRole
    let dateInscription: String

    enum CodingKeys: String, CodingKey {
        case id, username, email
        case firstName = "first_name"
        case lastName = "last_name"
        case birthday, age, gender, child
        case dateInscription = "date_inscription"
    }
}

// MARK: - Child
struct ChildRole: Codable {
    let id: Int
    let enabled: Bool
    let parent: ParentRole
}

// MARK: - Parent
struct ParentRole: Codable {
    let id: Int
    let username, firstName, lastName, email: String
    let gender, birthday, createdAt, modifiedAt: String

    enum CodingKeys: String, CodingKey {
        case id, username
        case firstName = "first_name"
        case lastName = "last_name"
        case email, gender, birthday
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
    }
}
