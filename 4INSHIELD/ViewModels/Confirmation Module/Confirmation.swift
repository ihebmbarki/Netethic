//
//  Confirmation.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 1/3/2023.
//

import UIKit
import SwiftKeychainWrapper

class Confirmation: UIViewController {

    @IBOutlet weak var viewOTP: PinView!
    @IBOutlet weak var registerBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        viewOTP.setUpView()
        configurePinView()
    }
    
    func configurePinView() {
        var config:PinConfig!     = PinConfig()
        config.otpLength          = .six
        config.dotColor           = .black
        config.lineColor          = #colorLiteral(red: 0.1986600459, green: 0.3112253845, blue: 0.5295307636, alpha: 1)
        config.spacing            = 5
        config.isSecureTextEntry  = false
        config.showPlaceHolder    = false

        viewOTP.config = config
        viewOTP.setUpView()
        viewOTP.textFields[0].becomeFirstResponder()
    }
    
    @IBAction func ConfirmationBtnTapped(_ sender: Any) {
        guard let savedUserEmail: String = KeychainWrapper.standard.string(forKey: "userEmail") else {return}
        var otpCode:String = ""
        do {
            otpCode = try self.viewOTP.getOTP()
        } catch OTPError.inCompleteOTPEntry {
            print("Incomplete OTP Entry error")
        } catch let error {
            print(error.localizedDescription)
        }
        
        APIManager.shareInstance.verifyOTPActivationCode(email: savedUserEmail, codeOTP: String(otpCode)) { result in
            switch result {
            case .success(let isValidOTP):
                if let valid = isValidOTP as? Bool, valid {
                    APIManager.shareInstance.activateAccount(withEmail: savedUserEmail) { activated in
                        if activated {
                            print("DEBUG: Congrats: Your account associated to this email \(savedUserEmail) is now active!")
                            
                        }
                        
                    }
                    
                }
            case .failure(_):
                print("DEBUG: Congrats: Your account associated to this email \(savedUserEmail) is not active!")
            }
            
        }
    }
    
   
}



