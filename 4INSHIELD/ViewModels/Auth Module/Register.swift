//
//  Register.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 27/2/2023.
//

import UIKit
import FSCalendar
import DropDown

class Register: KeyboardHandlingBaseVC {
    
    //IBOutlets
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var createAccLbl: UILabel!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var register_google: UIButton!
    @IBOutlet weak var register_facebook: UIButton!
    @IBOutlet weak var haveAccLbl: UILabel!
    @IBOutlet weak var changeLanguageBtn: UIButton!
    
    var selectedGender : String?
    
    
    @IBOutlet weak var genderLabel: UILabel!
    
    
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.contentInsetAdjustmentBehavior = .never
            
        }
    }
    
    @IBOutlet weak var calenderButton: UIButton!
    @IBOutlet weak var calenderTextField: UITextField!
    
    
    var sexe: String = "M"
    var iconClick = false
    let imageicon1 = UIImageView(frame: CGRect(x: 8, y: 8, width: 24, height: 24))
    let imageicon2 = UIImageView(frame: CGRect(x: 8, y: 8, width: 24, height: 24))
    let menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [
            "    Homme",
            "    Femme"
        ]
        return menu
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerBtn.setImage(UIImage(named: "next")!.withTintColor(.white, renderingMode: .alwaysTemplate), for: .normal)
        registerBtn.imageEdgeInsets = UIEdgeInsets(top : 0, left : 0 , bottom : 0, right : -250)
        
        menu.anchorView = genderView
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapTopItem))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        genderView.addGestureRecognizer(gesture)
        menu.selectionAction = { index, title in
            print(index)
            print(title)
            self.genderLabel.text = title
        }
        
        calenderButton.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        // Set the initial language based on the saved language
        if let selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
            LanguageManager.shared.currentLanguage = selectedLanguage
        }
        
        // Update localized strings
        updateLocalizedStrings()
        
        //Text fields lefrt side images
        usernameTF.setupLeftSideImages(ImageViewNamed: "user")
        emailTF.setupLeftSideImages(ImageViewNamed: "mail1")
        passwordTF.setupLeftSideImages(ImageViewNamed: "password")
        confirmPasswordTF.setupLeftSideImages(ImageViewNamed: "password")
        calenderTextField.setupLeftSideImage(ImageViewNamed: "calendar")
        calenderButton.setImage(UIImage(named: "calendar")!.withTintColor(UIColor(named: "AccentColor")!, renderingMode: .alwaysTemplate), for: .normal)
        calenderButton.contentVerticalAlignment = .center
        
        
        
        
        //text fields style
        usernameTF.setupBorderTFs()
        emailTF.setupBorderTFs()
        passwordTF.setupBorderTFs()
        confirmPasswordTF.setupBorderTFs()
        calenderTextField.setupBorderTFs()
        
        genderLabel.layer.borderWidth = 1
        genderLabel.layer.cornerRadius = 5
        genderLabel.layer.borderColor = UIColor(named: "gris")?.cgColor
        
        
        
        //Buttons style
        registerBtn.applyGradients()
        registerBtn.setupBorderBtn()
        //register_google.setupBorderBtns()
        //    register_facebook.setupBorderBtns()
        
        visualiserPassword1()
        visualiserPassword2()

    }
    @objc func didTapTopItem(){
        menu.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLocalizedStrings()
        updateLanguageButtonImage()
    }
    
    func updateLanguageButtonImage() {
        if let selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
            if selectedLanguage == "fr" {
                changeLanguageBtn.setImage(UIImage(named: "fr_white1"), for: .normal)
            } else if selectedLanguage == "en" {
                changeLanguageBtn.setImage(UIImage(named: "eng_white1"), for: .normal)
            }
        }
    }
    
    
    func visualiserPassword1(){
        imageicon1.image = UIImage(named: "closeeye")?.withRenderingMode(.alwaysTemplate)
        imageicon1.tintColor = .black
        let imageViewContainerView1 = UIView(frame: CGRect(x: 0, y: 0, width: 42, height: 40))
        imageViewContainerView1.addSubview(imageicon1)
        passwordTF.rightView = imageViewContainerView1
        passwordTF.rightViewMode = .always
        
         
        let tapGestureRecongnizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTaped(tapGestureRecongnizer1: )))
        imageicon1.isUserInteractionEnabled = true
        imageicon1.addGestureRecognizer(tapGestureRecongnizer1)
    }
    
    @objc func imageTaped(tapGestureRecongnizer1: UITapGestureRecognizer){
        let tappedImage1 = tapGestureRecongnizer1.view as!UIImageView
        if iconClick{
            iconClick = false
            tappedImage1.image = UIImage(named: "openeye")
            passwordTF.isSecureTextEntry = false

        }
        else{
            iconClick = true
            tappedImage1.image = UIImage(named: "closeeye")
            passwordTF.isSecureTextEntry = true
        }
    }
    
    func visualiserPassword2(){
        imageicon2.image = UIImage(named: "closeeye")?.withRenderingMode(.alwaysTemplate)
        imageicon2.tintColor = .black
        let imageViewContainerView2 = UIView(frame: CGRect(x: 0, y: 0, width: 42, height: 40))
        imageViewContainerView2.addSubview(imageicon2)
        confirmPasswordTF.rightView = imageViewContainerView2
        confirmPasswordTF.rightViewMode = .always
        
         
        let tapGestureRecongnizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTaped(tapGestureRecongnizer2: )))
        imageicon2.isUserInteractionEnabled = true
        imageicon2.addGestureRecognizer(tapGestureRecongnizer2)
    }
    
    @objc func imageTaped(tapGestureRecongnizer2: UITapGestureRecognizer){
        let tappedImage2 = tapGestureRecongnizer2.view as!UIImageView
        if iconClick{
            iconClick = false
            tappedImage2.image = UIImage(named: "openeye")
            confirmPasswordTF.isSecureTextEntry = false

        }
        else{
            iconClick = true
            tappedImage2.image = UIImage(named: "closeeye")
            confirmPasswordTF.isSecureTextEntry = true
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
                    self.changeLanguageBtn.setImage(UIImage(named: "eng_white1"), for: .normal)
                } else if action.title == "Français" {
                    LanguageManager.shared.currentLanguage = "fr"
                    UserDefaults.standard.set("fr", forKey: "selectedLanguage")
                    self.changeLanguageBtn.setImage(UIImage(named: "fr_white1"), for: .normal)
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
        createAccLbl.text = NSLocalizedString("create_account", tableName: nil, bundle: bundle, value: "", comment: "sign up label")
        usernameTF.placeholder = NSLocalizedString("your_username", tableName: nil, bundle: bundle, value: "", comment: "username")
        emailTF.placeholder = NSLocalizedString("e_mail", tableName: nil, bundle: bundle, value: "", comment: "email")
        passwordTF.placeholder = NSLocalizedString("Password", tableName: nil, bundle: bundle, value: "", comment: "Password")
        confirmPasswordTF.placeholder = NSLocalizedString("re_type_password", tableName: nil, bundle: bundle, value: "", comment: "Confirm Password")
        registerBtn.setTitle(NSLocalizedString("sign_up", tableName: nil, bundle: bundle, value: "", comment: "sign up"), for: .normal)
        signInBtn.setTitle(NSLocalizedString("Login", tableName: nil, bundle: bundle, value: "", comment: "Login"), for: .normal)
        haveAccLbl.text = NSLocalizedString("text_login", tableName: nil, bundle: bundle, value: "", comment: "text login")
        /*    register_google.setTitle(NSLocalizedString("signup_google", tableName: nil, bundle: bundle, value: "", comment: "sign up google"), for: .normal)
         register_facebook.setTitle(NSLocalizedString("signup_facebook", tableName: nil, bundle: bundle, value: "", comment: "sign up facebook"), for: .normal) */
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func goToConfirmation(withId identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ConfirmationVC = storyboard.instantiateViewController(withIdentifier: identifier)
        navigationController?.pushViewController(ConfirmationVC, animated: true)
    }
    
    
    func resetFields() {
        usernameTF.text = ""
        emailTF.text = ""
        passwordTF.text = ""
        confirmPasswordTF.text = ""
    }
    
    @objc func showDatePicker() {
        // Create the alert controller
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)
        
        // Configure the date picker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.frame = CGRect(x: 0, y: 0, width: 270, height: 216)
        
        // Add the date picker to the alert controller
        alertController.view.addSubview(datePicker)
        
        // Add the "Done" button to dismiss the alert controller
        alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            // Update the text field with the selected date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            print(dateFormatter.string(from: datePicker.date))
            
            self.calenderTextField.text = dateFormatter.string(from: datePicker.date)
        }))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func registerBtnTapped(_ sender: Any) {
        guard let username = self.usernameTF.text else { return }
        guard let email = self.emailTF.text else { return }
        guard let password = self.passwordTF.text else { return }
        selectedGender = genderLabel.text
        
        if selectedGender == "Homme"{
            sexe = "M"
        }
        if selectedGender == "Femme"{
            sexe = "F"
        }
        let stringDate = calenderTextField.text ?? "2002-02-02"
        let register = RegisterModel(username: username, email: email, email_verification_url: email, password: password, birthday: stringDate, gender: sexe, first_name: username, last_name: username)
        APIManager.shareInstance.registerAPI(register: register) { (isSuccess, str) in
            if isSuccess {
               // self.showAlert(message: str)
                self.goToConfirmation(withId: "ConfirmationID")
                UserDefaults.standard.set(email, forKey: "userEmail")
                UserDefaults.standard.synchronize()
            }else {
                self.showAlert(message: str)
            }
        }
        self.resetFields()
    }
        
        
        
        @IBAction func signInButton(_ sender: Any) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "signIn")
            navigationController?.pushViewController(VC, animated: true)
        }
        
        @IBAction func signUpGoogleTapped(_ sender: Any) {
        }
        
        
        @IBAction func signUpFacebookTapped(_ sender: Any) {
        }
        
    @IBAction func calenderButton(_ sender: Any) {
    }
    
        
}

extension UITextField {
    
    func setupLeftSideImages(ImageViewNamed: String) {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imageView.image = UIImage(named: ImageViewNamed)?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(named: "AccentColor")
        let imageViewContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageViewContainerView.addSubview(imageView)
        leftView = imageViewContainerView
        leftViewMode = .always
        
     
    }
    
    func setupBorderTFs() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: "gris")?.cgColor

    }
}

extension UIButton{
    
    func applyGradients () {
        let gradientLayer = CAGradientLayer()
   //     gradientLayer.colors = [UIColor(red: 0.25, green: 0.56, blue: 0.80, alpha: 1.00).cgColor,UIColor(red: 0.24, green: 0.76, blue: 0.95, alpha: 1.00).cgColor]
        gradientLayer.cornerRadius = layer.cornerRadius
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupBorderBtns() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1.00).cgColor
    }
}

