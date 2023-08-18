//
//  UpdateViewController.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 2/5/2023.
//

import UIKit
import Foundation
import DLRadioButton
import PhoneNumberKit

class UpdateViewController: KeyboardHandlingBaseVC, UITextFieldDelegate, deleteAlertDelegate {
    
    @IBOutlet weak var prenomTf: UITextField!
    @IBOutlet weak var nomTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    
    @IBOutlet weak var prenomLbl: UILabel!
    @IBOutlet weak var nomLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var genreLbl: UILabel!
    @IBOutlet weak var femmeLbl: UILabel!
    @IBOutlet weak var hommeLbl: UILabel!
    @IBOutlet weak var nonPreciseLbl: UILabel!
    @IBOutlet weak var deleteAccLbl: UILabel!
    @IBOutlet weak var deleteTextView: UITextView!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var parent1Btn: DLRadioButton!
    @IBOutlet weak var parent2: DLRadioButton!
    @IBOutlet weak var prent3: DLRadioButton!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var calendarButton: UIButton!
    
    @IBOutlet weak var nameError: UILabel!
    @IBOutlet weak var lastnameError: UILabel!
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var dateError: UILabel!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var gender: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Listen for language change notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleLanguageChangeNotification), name: NSNotification.Name("LanguageChangedNotification"), object: nil)
        
        // Initial setup of localized strings
        updateLocalizedStrings()
        
        resetForm()
        
        //Setup deleteview
        deleteView.layer.cornerRadius = 5.0
        deleteView.clipsToBounds = true
        deleteView.layer.borderWidth = 0.5
        deleteView.layer.borderColor = UIColor(named: "grisBorder")?.cgColor
//        deleteView.layer.shadowColor = UIColor(named: "grisBorder")?.cgColor
//        deleteView.layer.shadowOffset = CGSize(width: 0.0, height:1.0)
//        deleteView.layer.shadowOpacity = 0.5
//        deleteView.layer.shadowRadius = 0.0
//        deleteView.layer.masksToBounds = false
        
        //Utilities
        setUpDesign()
        getCurrentUserData()
        self.emailTf.isEnabled = false
        
        //Radio Buttons group property
        parent1Btn.otherButtons = [parent2, prent3]
        parent2.otherButtons = [parent1Btn, prent3]
        prent3.otherButtons = [parent1Btn, parent2]

        //Set the corner radius
        parent1Btn.layer.cornerRadius = parent1Btn.frame.width / 2
        parent2.layer.cornerRadius = parent2.frame.width / 2
        prent3.layer.cornerRadius = prent3.frame.width / 2
        
        // Set up the button's action
        calendarButton.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
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
        
        prenomLbl.text = NSLocalizedString("First_name", tableName: nil, bundle: bundle, value: "", comment: "")
        nomLbl.text = NSLocalizedString("Last_name", tableName: nil, bundle: bundle, value: "", comment: "")
        emailLbl.text = NSLocalizedString("e_mail", tableName: nil, bundle: bundle, value: "", comment: "")
        genreLbl.text = NSLocalizedString("Gender", tableName: nil, bundle: bundle, value: "", comment: "")
        dateLbl.text = NSLocalizedString("birthday", tableName: nil, bundle: bundle, value: "", comment: "")
        hommeLbl.text = NSLocalizedString("male", tableName: nil, bundle: bundle, value: "", comment: "")
        femmeLbl.text = NSLocalizedString("Female", tableName: nil, bundle: bundle, value: "", comment: "")
        nonPreciseLbl.text = NSLocalizedString("other", tableName: nil, bundle: bundle, value: "", comment: "")
        deleteAccLbl.text = NSLocalizedString("supp_acc", tableName: nil, bundle: bundle, value: "", comment: "")
        deleteTextView.text = NSLocalizedString("supp_acc_text", tableName: nil, bundle: bundle, value: "", comment: "add media")
        deleteBtn.setTitle(NSLocalizedString("supp", tableName: nil, bundle: bundle, value: "", comment: ""), for: .normal)
        updateBtn.setTitle(NSLocalizedString("update", tableName: nil, bundle: bundle, value: "", comment: ""), for: .normal)
        cancelBtn.setTitle(NSLocalizedString("cancel", tableName: nil, bundle: bundle, value: "", comment: ""), for: .normal)
    }
    
    func resetForm() {
        updateBtn.isEnabled = false

        nameError.isHidden = true
        lastnameError.isHidden = true
        emailError.isHidden = true
        dateError.isHidden = true
    }
    
    func checkForValidForm()
    {
        if nameError.isHidden && lastnameError.isHidden && emailError.isHidden && dateError.isHidden
        {
            updateBtn.isEnabled = true
        }
        else
        {
            updateBtn.isEnabled = false
        }
    }
    
    @IBAction func nameChanged(_ sender: Any) {
        if let firstname = prenomTf.text {
             if let errorMessage = invalidName(firstname) {
                 nameError.text = errorMessage
                 nameError.isHidden = false
                 prenomTf.layer.borderColor = UIColor(named: "redControl")?.cgColor
                 prenomTf.setupRightSideImage(image: "error", colorName: "redControl")
             } else {
                 nameError.isHidden = true
                 prenomTf.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
                 prenomTf.setupRightSideImage(image: "done", colorName: "vertDone")
             }
         }
         
         checkForValidForm()
    }
    
    func invalidName(_ value: String) -> String?
        {
            if value.isEmpty {
                if LanguageManager.shared.currentLanguage == "fr"{
                return "Ce champ ne peut pas être vide. "
                }
                if LanguageManager.shared.currentLanguage == "en"{
                return "This field cannot be blank."
                }
            }
            return nil
        }
    
    @IBAction func lastnameChanged(_ sender: Any) {
        if let lastname = nomTf.text {
             if let errorMessage = invalidlastName(lastname) {
                 lastnameError.text = errorMessage
                 lastnameError.isHidden = false
                 nomTf.layer.borderColor = UIColor(named: "redControl")?.cgColor
                 nomTf.setupRightSideImage(image: "error", colorName: "redControl")
             } else {
                 lastnameError.isHidden = true
                 nomTf.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
                 nomTf.setupRightSideImage(image: "done", colorName: "vertDone")
             }
         }
         checkForValidForm()
    }
    
    func invalidlastName(_ value: String) -> String?
        {
            if value.isEmpty {
                if LanguageManager.shared.currentLanguage == "fr"{
                return "Ce champ ne peut pas être vide. "
                }
                if LanguageManager.shared.currentLanguage == "en"{
                return "This field cannot be blank."
                }
            }
            return nil
        }
    
    @IBAction func emailChanged(_ sender: Any) {
        if let email = emailTf.text {
            if let errorMessage = invalidEmail(email) {
                emailError.text = errorMessage
                emailError.isHidden = false
                emailTf.layer.borderColor = UIColor(named: "redControl")?.cgColor
                emailTf.setupRightSideImage(image: "error", colorName: "redControl")
            } else {
                emailError.isHidden = true
                emailTf.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
                emailTf.setupRightSideImage(image: "done", colorName: "vertDone")
            }
        }
        checkForValidForm()
    }
    
    func invalidEmail(_ value: String) -> String?
    {
        if value.isEmpty {
            if LanguageManager.shared.currentLanguage == "fr"{
            return "Ce champ ne peut pas être vide. "
            }
            if LanguageManager.shared.currentLanguage == "en"{
            return "This field cannot be blank."
            }
        }
        
        let reqularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        
        if !predicate.evaluate(with: value) {
            if LanguageManager.shared.currentLanguage == "fr" {
                return "Votre email n'est pas valide !"
            } else {
                return "Your email is not valid!"
            }
        }
        return nil
    }
    
    @IBAction func dateChanged(_ sender: Any) {
        if let date = dateTextField.text {
            if let errorMessage = invalidDate(date) {
                dateError.text = errorMessage
                dateError.isHidden = false
                dateTextField.layer.borderColor = UIColor(named: "redControl")?.cgColor
            } else {
                dateError.isHidden = true
                dateTextField.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
            }
        }
        checkForValidForm()
    }
    
    func invalidDate(_ value: String) -> String?
    {
        if value.isEmpty {
            if LanguageManager.shared.currentLanguage == "fr"{
            return "Ce champ ne peut pas être vide. "
            }
            if LanguageManager.shared.currentLanguage == "en"{
            return "This field cannot be blank."
            }
        }
        return nil
    }
    
    let phoneNumberKit = PhoneNumberKit()
    var formattedText: String?

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let fullText = (text as NSString).replacingCharacters(in: range, with: string)
        do {
            let phoneNumber = try phoneNumberKit.parse(fullText)
            let countryCode = phoneNumberKit.mainCountry(forCode: phoneNumber.countryCode)?.uppercased() ?? ""
            let flag = emojiFlag(for: countryCode)
            formattedText = "\(flag) +\(phoneNumber.countryCode) \(phoneNumberKit.format(phoneNumber, toType: .national))"
        } catch {
            formattedText = fullText
        }
        textField.text = formattedText
        return false
    }

    func emojiFlag(for countryCode: String) -> String {
        let base = UnicodeScalar("🇦").value - UnicodeScalar("A").value
        var flagString = ""
        for scalar in countryCode.unicodeScalars {
            if let scalarValue = UnicodeScalar(base + scalar.value) {
                flagString.append(Character(scalarValue))
            }
        }
        return flagString
    }
    
    func getCurrentUserData() {
        guard let savedUserName = UserDefaults.standard.string(forKey: "username") else { return }
        DispatchQueue.main.async {
            APIManager.shareInstance.fetchCurrentUserData(username: savedUserName) { user in
                self.prenomTf.text = user.first_name
                self.nomTf.text = user.last_name
                self.emailTf.text = user.email
                self.dateTextField.text = user.birthday

                if user.gender == "M" {
                    self.parent1Btn.isSelected = true
                } else if user.gender ==  "F" {
                    self.parent2.isSelected = true
                } else {
                    self.prent3.isSelected = true
                }
            }
        }
    }
    
    func setUpDesign() {
        //Add Padding to Textfields
        let prenomPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        let nomPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        let emailPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        let datePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        
        //Set up firstname textfield
        prenomTf.layer.borderWidth = 1
        prenomTf.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
        prenomTf.layer.cornerRadius = prenomTf.frame.size.height/2
        prenomTf.layer.masksToBounds = true
        prenomTf.leftView = prenomPaddingView
        prenomTf.leftViewMode = .always
        
        //Set up lastname textfield
        nomTf.layer.borderWidth = 1
        nomTf.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
        nomTf.layer.cornerRadius = nomTf.frame.size.height/2
        nomTf.layer.masksToBounds = true
        nomTf.leftView = nomPaddingView
        nomTf.leftViewMode = .always
        
        //Set up date textfield
        dateTextField.layer.borderWidth = 1
        dateTextField.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
        dateTextField.layer.cornerRadius = dateTextField.frame.size.height/2
        dateTextField.layer.masksToBounds = true
        dateTextField.leftView = datePaddingView
        dateTextField.leftViewMode = .always
        
        //Set up email textfield
        emailTf.layer.borderWidth = 1
        emailTf.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
        emailTf.layer.cornerRadius = emailTf.frame.size.height/2
        emailTf.layer.masksToBounds = true
        emailTf.leftView = emailPaddingView
        emailTf.leftViewMode = .always
        
        //Set up buttons
        cancelBtn.layer.borderWidth = 0.5
        cancelBtn.layer.borderColor = UIColor(named: "grisBorder")?.cgColor
        cancelBtn.layer.shadowColor = UIColor(named: "grisBorder")?.cgColor
        cancelBtn.layer.shadowOffset = CGSize(width: 0.0, height:1.0)
        cancelBtn.layer.shadowOpacity = 0.5
        cancelBtn.layer.shadowRadius = 0.0
        cancelBtn.layer.masksToBounds = false
        cancelBtn.layer.cornerRadius = cancelBtn.frame.size.height/2
        cancelBtn.layer.masksToBounds = true
        
        updateBtn.layer.cornerRadius = updateBtn.frame.size.height/2
        updateBtn.layer.masksToBounds = true
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
            self.dateTextField.text = dateFormatter.string(from: datePicker.date)
            self.dateError.isHidden = true
            self.dateTextField.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
        }))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func radioButtonTapped(_ sender: DLRadioButton) {
        switch sender.tag {
        case 0:
            gender = "M"
        case 1:
            gender = "F"
        case 2:
            gender = "O"
        default:
            break
        }
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Children", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChildrenListSB")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func updateBtnTapped(_ sender: Any) {
        guard let userID = UserDefaults.standard.object(forKey: "userID") as? Int else { return }
        guard let savedUserName = UserDefaults.standard.string(forKey: "username") else { return }
        
        guard let fName = prenomTf.text, !fName.isEmpty else {
            let alertController = UIAlertController(title: "Failed", message: "Enter your first name please!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        guard let lname = nomTf.text, !lname.isEmpty else {
            let alertController = UIAlertController(title: "Failed", message: "Enter your last name please!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
//        print("Username: \(username)")
        
        guard let email = emailTf.text, !email.isEmpty else {
            let alertController = UIAlertController(title: "Failed", message: "Enter your email please!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        guard let date = dateTextField.text, !date.isEmpty else {
            let alertController = UIAlertController(title: "Failed", message: "Enter your birth date please!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        let updateData = [
            "parent": userID,
            "first_name": fName ,
            "last_name": lname ,
            "email": email ,
//            "numero": numero ,
            "birthday": date,
            "gender": gender,
        ] as [String : Any]
        
        APIManager.shareInstance.updateUserInfo(withuserName: savedUserName, updateData: updateData) { result in
            switch result {
            case .success(let updatedUser):
                print("Updated user: \(updatedUser)")
                //Success alert
                let alertController = UIAlertController(title: "Success", message: "Parent informations updated successfully", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)

            case .failure(let error):
                print("Error updating user info: \(error.localizedDescription)")
                // Handle error case, e.g. display error alert to user
            }
        }
    }
    

    @IBAction func deleteAccBtnTapped(_ sender: Any) {
        let deleteCustomAlert = self.storyboard?.instantiateViewController(identifier: "deleteCustomAlertID") as! CustomDeleteAlertView
        deleteCustomAlert.delegate  = self
        deleteCustomAlert.modalPresentationStyle = .overCurrentContext
        deleteCustomAlert.providesPresentationContextTransitionStyle = true
        deleteCustomAlert.definesPresentationContext = true
        deleteCustomAlert.modalTransitionStyle = .coverVertical
        self.present(deleteCustomAlert, animated: true, completion: nil)
    }
    
    
}
