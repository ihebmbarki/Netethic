//
//  Confirmation.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 1/3/2023.
//

import UIKit


class Confirmation: UIViewController, UITextFieldDelegate {
    
    //IBOutlets
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var enterCodeLbl: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var firstOtpTf: UITextField!
    @IBOutlet weak var secondOtpTf: UITextField!
    @IBOutlet weak var thirdOtpTf: UITextField!
    @IBOutlet weak var fourthOtpTf: UITextField!
    @IBOutlet weak var fifthOtpTf: UITextField!
    @IBOutlet weak var sixthOtpTf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //MARK: Translate
        welcomeLbl.text = NSLocalizedString("Welcome", comment: "welcome label")
        enterCodeLbl.text = NSLocalizedString("code", comment: "confirmation code")
        
        
        firstOtpTf.delegate = self
        secondOtpTf.delegate = self
        thirdOtpTf.delegate = self
        fourthOtpTf.delegate = self
        fifthOtpTf.delegate = self
        sixthOtpTf.delegate = self
    }
    
    //limit the user input to one character per text field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.count ?? 0) + string.count - range.length
        return newLength <= 1
    }
    
    //move the focus to the next text field when the user presses the "Next" button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    //Append entries
    let otpCode = "(firstOtpTf.text!)(secondOtpTf.text!)(thirdOtpTf.text!)(fourthOtpTf.text!)(fifthOtpTf.text!)(sixthOtpTf.text!)"
    
    @IBAction func ConfirmationBtnTapped(_ sender: Any) {
        
        //        APIManager.shareInstance.verifyOTPActivationCode(email: savedUserEmail, codeOTP: String(otpCode)) { result in
        //            switch result {
        //            case .success(let isValidOTP):
        //                if let valid = isValidOTP as? Bool, valid {
        //                    APIManager.shareInstance.activateAccount(withEmail: savedUserEmail) { activated in
        //                        if activated {
        //                            print("DEBUG: Congrats: Your account associated to this email \(savedUserEmail) is now active!")
        //
        //                        }
        //
        //                    }
        //
        //                }
        //            case .failure(_):
        //                print("DEBUG: Congrats: Your account associated to this email \(savedUserEmail) is not active!")
        //            }
        //
        //        }
        //    }
        
        
    }
    
    
    
}
