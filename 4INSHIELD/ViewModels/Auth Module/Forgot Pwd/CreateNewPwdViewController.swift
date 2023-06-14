//
//  CreateNewPwdViewController.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 7/4/2023.
//

import UIKit

class CreateNewPwdViewController: UIViewController {
    
    @IBOutlet weak var changeLanguageBtn: UIButton!
    @IBOutlet weak var createPwdLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var passwordTf1: UITextField!
    @IBOutlet weak var passwordTf2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        confirmBtn.roundCorners(5)
        confirmBtn.applyGradient()
    }
    
    func resetFields() {
        passwordTf1.text = ""
        passwordTf2.text = ""
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

        createPwdLbl.text = NSLocalizedString("new_password", tableName: nil, bundle: bundle, value: "", comment: "new password")
        descriptionLbl.text = NSLocalizedString("new_password1", tableName: nil, bundle: bundle, value: "", comment: "description label")
        passwordTf1.placeholder = NSLocalizedString("Password", tableName: nil, bundle: bundle, value: "", comment: "new pass")
        passwordTf2.placeholder = NSLocalizedString("re_type_password", tableName: nil, bundle: bundle, value: "", comment: "re_type_password")
        confirmBtn.setTitle(NSLocalizedString("Reset passs", tableName: nil, bundle: bundle, value: "", comment: "Reset pass"), for: .normal)
    }
    
    @IBAction func confirmBtnTapped(_ sender: Any) {
        guard let savedUserEmail = UserDefaults.standard.string(forKey: "userEmail") else { return }
        guard let pwd = passwordTf2.text else { return }

        DispatchQueue.main.async {
            APIManager.shareInstance.resetPassword(withEmail: savedUserEmail, newPassword: pwd, completion: { pwdChanged in
                if pwdChanged {
                    let alert = UIAlertController(title: "Good Job!", message: "Your new password is set", preferredStyle: .alert)
                    let nextAction = UIAlertAction(title: "Next", style: .default) { _ in
                        //Go To Sign In view
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let VC = storyboard.instantiateViewController(withIdentifier: "SignIn")
                        self.navigationController?.pushViewController(VC, animated: true)
                    }
                    alert.addAction(nextAction)
                    self.present(alert, animated: true, completion: nil)

                    self.resetFields()
                } else {
                    let alert = UIAlertController(title: "Failed", message: "Failed to update your password!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
        
    }
    
    
}
