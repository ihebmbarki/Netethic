//
//  ResetPwdViewController.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 7/4/2023.
//

import UIKit

class ResetPwdViewController: UIViewController {

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
