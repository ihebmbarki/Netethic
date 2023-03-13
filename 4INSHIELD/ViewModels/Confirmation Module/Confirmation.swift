//
//  Confirmation.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 1/3/2023.
//

import UIKit


class Confirmation: UIViewController, UITextFieldDelegate {
    
    //IBOutlets
    
    @IBOutlet weak var ChangeLanguageBtn: UIButton!
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
        
        firstOtpTf.delegate = self
        secondOtpTf.delegate = self
        thirdOtpTf.delegate = self
        fourthOtpTf.delegate = self
        fifthOtpTf.delegate = self
        sixthOtpTf.delegate = self
        
        registerBtn.applyGradient()
    }
    
    
    @IBAction func changeLanguageBtnTapped(_ sender: Any) {
        let languages = ["English", "Français"]
        let languageAlert = UIAlertController(title: "Choisir la langue", message: nil, preferredStyle: .actionSheet)

        for language in languages {
            let action = UIAlertAction(title: language, style: .default) { action in
                if action.title == "English" {
                    LanguageManager.shared.currentLanguage = "en"
                    UserDefaults.standard.set("en", forKey: "selectedLanguage")
                    self.ChangeLanguageBtn.setImage(UIImage(named: "eng_white"), for: .normal)
                } else if action.title == "Français" {
                    LanguageManager.shared.currentLanguage = "fr"
                    UserDefaults.standard.set("fr", forKey: "selectedLanguage")
                    self.ChangeLanguageBtn.setImage(UIImage(named: "fr_white"), for: .normal)
                }

                self.updateLocalizedStrings()
                self.view.setNeedsLayout() // Refresh the layout of the view
            }
            languageAlert.addAction(action)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        languageAlert.addAction(cancelAction)

        present(languageAlert, animated: true, completion: nil)
    }


    
    func updateLocalizedStrings() {
        let bundle = Bundle.main.path(forResource: LanguageManager.shared.currentLanguage, ofType: "lproj").flatMap(Bundle.init) ?? Bundle.main
            
        welcomeLbl.text = NSLocalizedString("Welcome", tableName: nil, bundle: bundle, value: "", comment: "welcome label")
        enterCodeLbl.text = NSLocalizedString("code", tableName: nil, bundle: bundle, value: "", comment: "confirmation code")
        registerBtn.setTitle(NSLocalizedString("Confirm", tableName: nil, bundle: bundle, value: "", comment: "Confirm"), for: .normal)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.count ?? 0) + string.count - range.length
        
        // Allow backspace
        if string.isEmpty {
            if let prevTextField = textField.superview?.viewWithTag(textField.tag - 1) as? UITextField {
                prevTextField.becomeFirstResponder()
            }
            textField.text = ""
            return false
        }
        
        // Limit to one character
        if newLength > 1 {
            return false
        }
        
        // Move to the next text field if there is input
        if let nextTextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField,
           !string.isEmpty {
            nextTextField.becomeFirstResponder()
        }
        
        // Fill the text field with the input
        textField.text = string
        
        return false
    }
    
    //Append entries
    let otpCode = "(firstOtpTf.text!)(secondOtpTf.text!)(thirdOtpTf.text!)(fourthOtpTf.text!)(fifthOtpTf.text!)(sixthOtpTf.text!)"
    
    @IBAction func ConfirmationBtnTapped(_ sender: Any) {
        guard let savedUserEmail = UserDefaults.standard.string(forKey: "userEmail") else {
            return
        }
        APIManager.shareInstance.verifyOTPActivationCode(email: savedUserEmail, codeOTP: String(otpCode)) { result in
            switch result {
            case .success:
                APIManager.shareInstance.activateAccount(withEmail: savedUserEmail) { activated in
                    if activated {
                        print("Your account associated to this email \(savedUserEmail) is now active!")
                    } else {
                        print("Your account associated to this email \(savedUserEmail) is not active!")
                    }
                }
                
                let alertController = UIAlertController(title: "Great Job!", message: "Your 4INSHIELD account has been successfully activated! Now you can login", preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "Login", style: .default, handler: { _ in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! Home
                    self.navigationController?.pushViewController(homeVC, animated: true)
                }))
                self.present(alertController, animated: true, completion: nil)
                
            case .failure(let error):
                print("This is a Non-valid/Expired OTP Code! Error: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "Oops", message: "This PIN code is expired or not valid! , please verify your code or ask for a new one", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    
    
    
}
