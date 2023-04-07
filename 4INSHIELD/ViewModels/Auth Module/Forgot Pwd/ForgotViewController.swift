//
//  ForgotViewController.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 6/4/2023.
//

import UIKit
import Foundation

class ForgotViewController: UIViewController {
    
    
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var emailTf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func resetFields() {
        emailTf.text = ""
    }
    
    
    @IBAction func reserBtnTapped(_ sender: Any) {
        guard let email = emailTf.text else { return }
        
        APIManager.shareInstance.fetchUsers { users in
            var exist = false
            users.forEach { user in
                if user.email == email {
                    exist = true
                }
            }
            if exist {
                //send the OTP code
                APIManager.shareInstance.generateOTPActivationCode(email: email, completion: { success in
                    if success {
                        print("OTP Code was generated successfully")
                    } else {
                        print("Error was occured while generating OTP Code!")
                    }
                })
                print("User \(email) exists")
                UserDefaults.standard.set(email, forKey: "userEmail")
                
                //Go To reset password view
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let VC = storyboard.instantiateViewController(withIdentifier: "ResetPwdPin")
                self.navigationController?.pushViewController(VC, animated: true)
            } else {
                print("User \(email) dosen't exists")
                let alert = UIAlertController(title: "Alert", message: "This email does not exist!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
}
