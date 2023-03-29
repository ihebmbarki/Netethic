//
//  Profil.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 29/3/2023.
//

import Foundation

struct Profil : Codable,Identifiable {
    
    let id: Int
//    let child: Int
    let social_media_name: String
    let pseudo: String
    let url: String?
}
