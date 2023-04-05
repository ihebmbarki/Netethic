//
//  Constant.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 28/2/2023.
//

import Foundation
import UIKit
import SDWebImage


//let CLIENT_ID = BuildConfiguration.shared.CLIENT_ID
//let CLIENT_SECRET = BuildConfiguration.shared.CLIENT_SECRET
//let base_url = "https://api.shield.kaisens.fr"
let register_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/auth/register/"
let login_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/auth/login/"
let otp_url =  "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/auth/verify-totp-token/"
let email_verif_url =  "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/auth/email-verify-app-mobile/"
let add_Child_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/childs/"
let user_journey_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/userjourney/"
//let user_step_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/users/\(username)/journey/"

let add_Child_Profile = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/profiles/"
let onboarding_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/users/"
let set_Onboarding_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/users/onboarding_simple/"













//Colors
struct Colrs {
    static let redColor = UIColor(red: 239, green: 82, blue: 96, alpha: 1)
    static let bgColor = UIColor(red: 63/255, green: 99/255, blue: 169/255, alpha: 1)
}
//Display
extension UIView {
    public func roundCorners(_ cornerRadius: CGFloat, borderWidth: CGFloat = 0) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
    }
}
//Image
extension UIImageView {
    
    func loadImage(_ urlString: String?, onSuccess:((UIImage) -> Void)? = nil) {
        self.image = UIImage()
        guard let string = urlString else {return}
        guard let url = URL(string: string) else {return}
        
        self.sd_setImage(with: url) { (image, error, type, url) in
            if onSuccess != nil , error == nil {
                onSuccess!(image!)
            }
        }
    }
    
    
}
