//
//  ChildrenResponse.swift
//  4INSHIELD
//
//  Created by kaisensData on 25/8/2023.
//

import Foundation

struct ChildrenResponse: Codable {

    let children: [Childd]

 

    enum CodingKeys: String, CodingKey {

        case children

    }

}

 

struct TopLevelResponse: Codable {

    let id: Int

    let username: String

    let email: String

    let first_name: String

    let last_name: String

    let birthday: String

    let age: Int

    let postal_code: String?

    let gender: String?

    let photo: String?

    let child: Childd?

    let date_inscription: String

    

    enum CodingKeys: String, CodingKey {

        case id, username, email, first_name, last_name, birthday, age, postal_code, gender, photo, child, date_inscription

    }

}

 

struct Childd: Codable {

    let id: Int

    let uuid: String?

    let enabled: Bool?

    let street: String?

    let country: Int?

    let subclassSchool: SubclassSchool?

    let adress: String?

    let user: Userr?

 

    enum CodingKeys: String, CodingKey {

        case id, uuid, enabled, street, country, subclassSchool = "subclass_school", adress = "adress", user

    }

}

 

struct SubclassSchool: Codable {

    let school: String?

    let subclass: String?

}

 

struct Userr: Codable {

    let username: String?

    let first_name: String?

    let last_name: String?

    let email: String?

    let onboarding_simple: Bool

    let onboarding_stepper: Bool

    let gender: String?

    let birthday: String

    let photo: String?

    let created_at: String

    let modified_at: String

    let user_role: String

    let is_active: Bool

}
