//
//  Profile.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 12/4/2023.
//

import Foundation

struct Profile: Codable,Identifiable {
    
    let id: Int
    let child: Int
    let social_media_name: Int
    let pseudo: String
    let name: String?
    let password: String?
    let created_at: String
    let modified_at: String
    let url: String?
}
