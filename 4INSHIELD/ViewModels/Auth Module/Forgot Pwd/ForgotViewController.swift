//
//  ForgotViewController.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 6/4/2023.
//

import UIKit
import Foundation

class ForgotViewController: UIViewController {
    
    @IBOutlet weak var forgotPwdTf: UILabel!
    @IBOutlet weak var descriptionTf: UILabel!
    @IBOutlet weak var changeLanguageBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var emailTf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        resetBtn.roundCorners(5)
        resetBtn.applyGradient()
    }

    func resetFields() {
        emailTf.text = ""
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: Translation
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLocalizedStrings()
        updateLanguageButtonImage()
    }
    func updateLanguageButtonImage() {
        if let selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
            if selectedLanguage == "fr" {
                changeLanguageBtn.setImage(UIImage(named: "fr_white"), for: .normal)
            } else if selectedLanguage == "en" {
                changeLanguageBtn.setImage(UIImage(named: "eng_white"), for: .normal)
            }
        }
    }
    
    @IBAction func changeLanguageBtnTapped(_ sender: Any) {
        let languages = ["English", "Français"]
        let languageAlert = UIAlertController(title: "Choisir la langue", message: nil, preferredStyle: .actionSheet)
        
        for language in languages {
            let action = UIAlertAction(title: language, style: .default) { action in
                if action.title == "English" {
                    LanguageManager.shared.currentLanguage = "en"
                    UserDefaults.standard.set("en", forKey: "selectedLanguage")
                    self.changeLanguageBtn.setImage(UIImage(named: "eng_white"), for: .normal)
                } else if action.title == "Français" {
                    LanguageManager.shared.currentLanguage = "fr"
                    UserDefaults.standard.set("fr", forKey: "selectedLanguage")
                    self.changeLanguageBtn.setImage(UIImage(named: "fr_white"), for: .normal)
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

        forgotPwdTf.text = NSLocalizedString("forget", tableName: nil, bundle: bundle, value: "", comment: "forgot pwd label")
        descriptionTf.text = NSLocalizedString("tag_reset", tableName: nil, bundle: bundle, value: "", comment: "description label")
        emailTf.placeholder = NSLocalizedString("e_mail", tableName: nil, bundle: bundle, value: "", comment: "email")
        resetBtn.setTitle(NSLocalizedString("send", tableName: nil, bundle: bundle, value: "", comment: "send code"), for: .normal)
    }
    
    //MARK: Generate code
    
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
                        //Go To reset password view
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let VC = storyboard.instantiateViewController(withIdentifier: "ResetPwdPin")
                        self.navigationController?.pushViewController(VC, animated: true)
                    } else {
                        print("Error was occured while generating OTP Code!")
                    }
                })
                print("User \(email) exists")
                UserDefaults.standard.set(email, forKey: "userEmail")
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

