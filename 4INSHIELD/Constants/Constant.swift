//
//  Constant.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 28/2/2023.
//

import Foundation

//let CLIENT_ID = BuildConfiguration.shared.CLIENT_ID
//let CLIENT_SECRET = BuildConfiguration.shared.CLIENT_SECRET
//let base_url = "https://api.shield.kaisens.fr"
let register_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/auth/register/"
let login_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/auth/login/"
let otp_url =  "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/auth/verify-totp-token/"
let email_verif_url =  "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/auth/email-verify-app-mobile/"
