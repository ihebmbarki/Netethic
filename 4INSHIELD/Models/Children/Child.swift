//
//  Child.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 30/3/2023.
//

import Foundation

struct Child: Codable,Identifiable {
    let id: Int
    let parent: Int
    let first_name: String
    let last_name: String
    let birthday: String
    let gender: String
    let meta: String?
    let photo: String?
    let address: String?
    let created_at: String
    let modified_at: String
    let url: String
    let issync: Bool

    
}
