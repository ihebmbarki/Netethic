//
//  CustomDeleteAlertView.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 10/8/2023.
//

import UIKit

protocol deleteAlertDelegate {
    
}

class CustomDeleteAlertView: KeyboardHandlingBaseVC {
    
    @IBOutlet weak var alertDeleteView: UIView!{
        didSet {
            alertDeleteView.backgroundColor = UIColor.white
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.contentInsetAdjustmentBehavior = .never
        }
    }
    @IBOutlet weak var alertLbl: UILabel!
    @IBOutlet weak var enterUsernameLbl: UILabel!
    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var usernameErrorLbl: UILabel!
    
    @IBOutlet weak var cancelBtn: UIButton!{
        didSet{
            cancelBtn.layer.shadowColor = UIColor.black.cgColor
                 cancelBtn.layer.shadowOpacity = 0.5
                 cancelBtn.layer.shadowOffset = CGSize(width: 0, height: 2)
                 cancelBtn.layer.shadowRadius = 4
        }
    }
    @IBOutlet weak var deleteBtn: UIButton!{
        didSet{
            deleteBtn.layer.shadowColor = UIColor.black.cgColor
                  deleteBtn.layer.shadowOpacity = 0.5
                  deleteBtn.layer.shadowOffset = CGSize(width: 0, height: 2)
                  deleteBtn.layer.shadowRadius = 4
        }
    }
    
    var delegate:deleteAlertDelegate? = nil
    
    override func viewDidLoad( ) {
        super.viewDidLoad()
//        view.backgroundColor = UIColor.white
        scrollView.backgroundColor = UIColor.black.withAlphaComponent(0.8)

        // Listen for language change notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleLanguageChangeNotification), name: NSNotification.Name("LanguageChangedNotification"), object: nil)
        
        resetForm()
        
        // Make the UITextField borderless with an underline
        usernameTf.borderStyle = .none
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: usernameTf.frame.height - 1, width: usernameTf.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.white.cgColor
        usernameTf.layer.addSublayer(bottomLine)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    func setupView() {
        alertDeleteView.layer.cornerRadius = 5
        alertDeleteView.backgroundColor = UIColor(white: 1, alpha: 0.8)
    }

    
    func animateView() {
        alertDeleteView.alpha = 0;
        self.alertDeleteView.frame.origin.y = self.alertDeleteView.frame.origin.y + 0
        UIView.animate(withDuration: 0.0, animations: { () -> Void in
            self.alertDeleteView.alpha = 1.0;
            self.alertDeleteView.frame.origin.y = self.alertDeleteView.frame.origin.y - 0
        })
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self, name: NSNotification.Name("LanguageChangedNotification"), object: nil)
     }

     @objc func handleLanguageChangeNotification() {
         // Update localized strings when language changes
         updateLocalizedStrings()
     }
    
    func updateLocalizedStrings() {
        let bundle = Bundle.main.path(forResource: LanguageManager.shared.currentLanguage, ofType: "lproj").flatMap(Bundle.init) ?? Bundle.main
        
        alertLbl.text = NSLocalizedString("supp_alert", tableName: nil, bundle: bundle, value: "", comment: "")
        enterUsernameLbl.text = NSLocalizedString("saisir_username", tableName: nil, bundle: bundle, value: "", comment: "")

        deleteBtn.setTitle(NSLocalizedString("delete", tableName: nil, bundle: bundle, value: "", comment: ""), for: .normal)
        cancelBtn.setTitle(NSLocalizedString("cancel", tableName: nil, bundle: bundle, value: "", comment: ""), for: .normal)
    }
    
    func resetForm() {
        deleteBtn.isEnabled = false

        usernameErrorLbl.isHidden = true

        usernameTf.text = ""
    }
    
    @IBAction func usernameChanged(_ sender: Any) {
        if let username = usernameTf.text {
            if let errorMessage = invalidUserName(username) {
                usernameErrorLbl.text = errorMessage
                usernameErrorLbl.isHidden = false
                usernameTf.layer.borderColor = UIColor(named: "redControl")?.cgColor
                usernameTf.setupRightSideImage(image: "error", colorName: "redControl")
            } else {
                usernameErrorLbl.isHidden = true
                usernameTf.layer.borderColor = UIColor(named: "grisBorder")?.cgColor
                usernameTf.setupRightSideImage(image: "done", colorName: "vertDone")
            }
        }
        
        checkForValidForm()
    }
    
    func checkForValidForm()
    {
        if usernameErrorLbl.isHidden
        {
            deleteBtn.isEnabled = true
            deleteBtn.setTitleColor(.white, for: .normal)

        }
        else
        {
            deleteBtn.isEnabled = false
        }
    }
    
    func invalidUserName(_ value: String) -> String?
        {
            if value.isEmpty {
                if LanguageManager.shared.currentLanguage == "fr"{
                return "Ce champ ne peut pas être vide. "
                }
                if LanguageManager.shared.currentLanguage == "en"{
                return "This field cannot be blank."
                }
            }

            let reqularExpression = "^[a-zA-Z0-9]{3,20}$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
            if !predicate.evaluate(with: value)
            {
                if LanguageManager.shared.currentLanguage == "fr"{
                return "Nom d'utilisateur non valide"

            }
                if LanguageManager.shared.currentLanguage == "en"{
                    return "Invalid username"
                }
                
            }
            
            return nil
        }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func deleteBtnTapped(_ sender: Any) {
        if let username = usernameTf.text, !username.isEmpty {
            // Make the API request to delete the user using the provided username
            APIManager.shareInstance.deleteUser(forUsername: username) { result in
                switch result {
                case .success:
                    // Success alert
                    let alertController = UIAlertController(title: "Success", message: "User deleted successfully!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                        // Dismiss the view controller
                        self.dismiss(animated: true, completion: nil)
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    // Failure alert
                    let alertController = UIAlertController(title: "Failed", message: "Failed to delete user", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                        // Dismiss the view controller
                        self.dismiss(animated: true, completion: nil)
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        } else {
            // Handle the case where the username is empty
            usernameErrorLbl.text = "Username is required"
            usernameErrorLbl.isHidden = false
        }
    }

    
    
    

}
