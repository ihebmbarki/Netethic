//
//  UserJourney.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 28/3/2023.
//

import Foundation

struct UserJourney: Codable,Identifiable {
    
    let id: Int
    let user: Int
    let wizard_step: Int
    let platform: String
    let date: String
    let created_at: String
    let modified_at: String
    
    init(dictionary: [String: Any]) {

        self.id = dictionary["id"] as? Int ?? 0
        self.user = dictionary["user"] as? Int ?? 0
        self.wizard_step = dictionary["wizard_step"] as? Int ?? 0
        self.platform = dictionary["platform"] as? String ?? "pseudo"
        self.date = dictionary["date"] as? String ?? "1998-02-04"
        self.created_at = dictionary["created_at"] as? String ?? "1998-02-04"
        self.modified_at = dictionary["modified_at"] as? String ?? "1998-02-04"
    }


}
