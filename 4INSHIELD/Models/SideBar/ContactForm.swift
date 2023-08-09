//
//  ContactForm.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 31/7/2023.
//

import Foundation

struct ContactForm: Encodable {
    let id_user: Int
    let subject: String
    let message: String
    let username: String
    let email: String
}
