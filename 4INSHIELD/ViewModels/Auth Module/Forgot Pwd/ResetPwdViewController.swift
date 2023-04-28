//
//  ResetPwdViewController.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 7/4/2023.
//

import UIKit

class ResetPwdViewController: UIViewController {

    @IBOutlet weak var changeLanguageBtn: UIButton!
    @IBOutlet weak var codeLbl: UILabel!
    @IBOutlet weak var enterCodeLbl: UILabel!
    @IBOutlet weak var viewOTP: PinView!
    @IBOutlet weak var confrimBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configurePinView()
    }
    
    func configureUI() {
        confrimBtn.roundCorners(5)
        confrimBtn.applyGradient()
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

        codeLbl.text = NSLocalizedString("code1", tableName: nil, bundle: bundle, value: "", comment: "confirmation code")
        enterCodeLbl.text = NSLocalizedString("code", tableName: nil, bundle: bundle, value: "", comment: "enter code")
        confrimBtn.setTitle(NSLocalizedString("Confirm", tableName: nil, bundle: bundle, value: "", comment: "Confirm pin"), for: .normal)
    }
    
    //MARK: Confirmation
    @IBAction func confirmBtnTapped(_ sender: Any) {
        guard let savedUserEmail = UserDefaults.standard.string(forKey: "userEmail") else { return }

        var otpCode:String = ""
        do {
            otpCode = try self.viewOTP.getOTP()

        } catch OTPError.inCompleteOTPEntry {
            print("Incomplete OTP Entry error")
        } catch let error {
            print(error.localizedDescription)
        }
        print("Typed OTP: ", otpCode)

        APIManager.shareInstance.verifyOTPCode(email: savedUserEmail, codeOTP: String(otpCode), completion: { isValidOTP in
            if isValidOTP {
                print("This is a valid OTP Code")

                let alert = UIAlertController(title: "Good Job!", message: "This PIN code is valid, click next to set your new password!", preferredStyle: .alert)
                let nextAction = UIAlertAction(title: "Next", style: .default) { _ in
                    //Go To create new password view
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let VC = storyboard.instantiateViewController(withIdentifier: "createNewPwd")
                    self.navigationController?.pushViewController(VC, animated: true)
                }
                alert.addAction(nextAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Failed", message: "This PIN code is not valid!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Okay", style: .default) { _ in
                    print("Okay")
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    
}
