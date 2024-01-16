//
//  Constant.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 28/2/2023.
//

import Foundation
import UIKit
//import SDWebImage


//let CLIENT_ID = BuildConfiguration.shared.CLIENT_ID
//let CLIENT_SECRET = BuildConfiguration.shared.CLIENT_SECRET
//let base_url = "https://api.shield.kaisens.fr"
let register_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)auth/register/"
let login_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/auth/login/"
let otp_url =  "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/auth/verify-totp-token/"
let email_verif_url =  "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/auth/email-verify-app-mobile/"
let add_Child_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/childs/"
let user_journey_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)api/userjourney/"
//let user_step_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/users/\(username)/journey/"

let add_Child_Profile = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/profiles/"
let onboarding_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/users/"
let set_Onboarding_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/users/onboarding_simple/"
let generate_newOtp_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/auth/generate-new-totp-token/"
let change_pwd_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/auth/change-password/"
let user_score = "\(BuildConfiguration.shared.MLENGINE_BASE_URL)/score/general/"
let contactFormURL = "\(BuildConfiguration.shared.CRAWLSERVER_BASE_URL)/api/support/contact_form/"
