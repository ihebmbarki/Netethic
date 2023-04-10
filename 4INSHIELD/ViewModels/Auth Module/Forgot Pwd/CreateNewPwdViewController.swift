//
//  CreateNewPwdViewController.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 7/4/2023.
//

import UIKit

class CreateNewPwdViewController: UIViewController {
    
    
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
