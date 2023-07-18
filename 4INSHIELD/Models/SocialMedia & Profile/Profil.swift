//
//  Profil.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 29/3/2023.
//

import Foundation

struct Wizard: Codable {
    let user, wizardStep: Int
    let platform, date: String

    enum CodingKeys: String, CodingKey {
        case user
        case wizardStep = "wizard_step"
        case platform, date
    }
}
struct WizardResponse: Codable {
    let id, user, wizardStep: Int
    let platform, date, createdAt, modifiedAt: String

    enum CodingKeys: String, CodingKey {
        case id, user
        case wizardStep = "wizard_step"
        case platform, date
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
    }
}



struct profil1 : Codable{
    let child: Int
    let social_media_name: Int
    let pseudo: String
    let url: String?
}
struct Profil: Codable {
    let id, child, socialMediaName: Int
    let socialMedia, pseudo: String
    let active: Bool
    let createdAt, modifiedAt, url: String

    enum CodingKeys: String, CodingKey {
        case id, child
        case socialMediaName = "social_media_name"
        case socialMedia = "social_media"
        case pseudo, active
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
        case url
    }
}

//struct Profil : Codable {
//
//    let id: Int
//    let child: Int
//    let social_media_name: Int
//    let pseudo: String
//    let name: String?
//    let password: String?
//    let created_at: String
//    let modified_at: String
//    let url: String?
//    let meta: String
//    let social_media: String
//    let active: Bool
    



//    init(dictionary: [String: Any]) {
//
//        self.id = dictionary["id"] as? Int ?? 0
//        self.child = dictionary["child"] as? Int ?? 0
//        self.social_media_name = dictionary["social_media_name"] as? Int ?? 0
//        self.social_media = dictionary["social_media"] as? String ?? ""
//        self.pseudo = dictionary["pseudo"] as? String ?? "pseudo"
//        self.name = dictionary["name"] as? String ?? ""
//        self.password = dictionary["password"] as? String ?? ""
//        self.created_at = dictionary["created_at"] as? String ?? "1998-02-04"
//        self.modified_at = dictionary["modified_at"] as? String ?? "1998-02-04"
//        self.url = dictionary["url"] as? String ?? ""
//        self.meta = dictionary["meta"] as? String ?? "meta"
//        self.active = dictionary["active"] as? Bool ?? true
//    }


//}

