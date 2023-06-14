//
//  Profil.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 29/3/2023.
//

import Foundation

//struct Profil : Codable,Identifiable {
//
//    let id: Int
////    let child: Int
//    let social_media_name: Int
//    let pseudo: String
//    let url: String?
//}


struct Profil : Codable,Identifiable {
    
    let id: Int
    let child: Int
    let social_media_name: Int
    let pseudo: String
    let name: String?
    let password: String?
    let created_at: String
    let modified_at: String
    let url: String?
    let meta: String


    init(dictionary: [String: Any]) {

        self.id = dictionary["id"] as? Int ?? 0
        self.child = dictionary["child"] as? Int ?? 0
        self.social_media_name = dictionary["social_media_name"] as? Int ?? 0
        self.pseudo = dictionary["pseudo"] as? String ?? "pseudo"
        self.name = dictionary["name"] as? String ?? ""
        self.password = dictionary["password"] as? String ?? ""
        self.created_at = dictionary["created_at"] as? String ?? "1998-02-04"
        self.modified_at = dictionary["modified_at"] as? String ?? "1998-02-04"
        self.url = dictionary["url"] as? String ?? ""
        self.meta = dictionary["meta"] as? String ?? "meta"
    }


}

