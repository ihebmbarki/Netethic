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

class UpdateViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var prenomTf: UITextField!
    @IBOutlet weak var nomTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var numeroTf: UITextField!
    
    @IBOutlet weak var parent1Btn: DLRadioButton!
    @IBOutlet weak var parent2: DLRadioButton!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var calendarButton: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    
    var gender: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Utilities
        setUpDesign()
        getCurrentUserData()
        
        //Set up phone number delegate
        numeroTf.delegate = self
        
        //Radio Buttons group property
        parent1Btn.otherButtons = [parent2]
        parent2.otherButtons = [parent1Btn]

        //Set the corner radius
        parent1Btn.layer.cornerRadius = parent1Btn.frame.width / 2
        parent2.layer.cornerRadius = parent2.frame.width / 2
        
        // Set up the button's action
        calendarButton.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
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

    func verifyPhoneNumber() {
        guard let text = numeroTf.text else { return }
        do {
            let phoneNumber = try phoneNumberKit.parse(text)
            print("Country code: \(phoneNumber.countryCode)")
            print("National number: \(phoneNumber.nationalNumber)")
            // Now you can use the parsed phone number for verification
        } catch {
            print("Error parsing phone number: \(error.localizedDescription)")
            // Handle the error here
        }
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
//        let savedUserName = "kaxavy"
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
                }
            }
        }
    }
    
    func setUpDesign() {
        //Add Padding to Textfields
        let prenomPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        let nomPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        let emailPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        let numeroPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        let datePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        
        //Set up firstname textfield
        prenomTf.layer.borderWidth = 1
        prenomTf.layer.borderColor = UIColor(red: 50/255, green: 126/255, blue: 192/255, alpha: 1).cgColor
        prenomTf.layer.cornerRadius = prenomTf.frame.size.height/2
        prenomTf.layer.masksToBounds = true
        prenomTf.leftView = prenomPaddingView
        prenomTf.leftViewMode = .always
        
        //Set up lastname textfield
        nomTf.layer.borderWidth = 1
        nomTf.layer.borderColor = UIColor(red: 50/255, green: 126/255, blue: 192/255, alpha: 1).cgColor
        nomTf.layer.cornerRadius = nomTf.frame.size.height/2
        nomTf.layer.masksToBounds = true
        nomTf.leftView = nomPaddingView
        nomTf.leftViewMode = .always
        
        //Set up date textfield
        dateTextField.layer.borderWidth = 1
        dateTextField.layer.borderColor = UIColor(red: 50/255, green: 126/255, blue: 192/255, alpha: 1).cgColor
        dateTextField.layer.cornerRadius = dateTextField.frame.size.height/2
        dateTextField.layer.masksToBounds = true
        dateTextField.leftView = datePaddingView
        dateTextField.leftViewMode = .always
        
        //Set up email textfield
        emailTf.layer.borderWidth = 1
        emailTf.layer.borderColor = UIColor(red: 50/255, green: 126/255, blue: 192/255, alpha: 1).cgColor
        emailTf.layer.cornerRadius = emailTf.frame.size.height/2
        emailTf.layer.masksToBounds = true
        emailTf.leftView = emailPaddingView
        emailTf.leftViewMode = .always
        
        //Set up numero textfield
        numeroTf.layer.borderWidth = 1
        numeroTf.layer.borderColor = UIColor(red: 50/255, green: 126/255, blue: 192/255, alpha: 1).cgColor
        numeroTf.layer.cornerRadius = numeroTf.frame.size.height/2
        numeroTf.layer.masksToBounds = true
        numeroTf.leftView = numeroPaddingView
        numeroTf.leftViewMode = .always
        
        //Set up buttons
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor(red: 50/255, green: 126/255, blue: 192/255, alpha: 1).cgColor
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
//        guard let numero = numeroTf.text, !lName.isEmpty else {
//            let alertController = UIAlertController(title: "Failed", message: "Enter your phone number please!", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alertController.addAction(okAction)
//            present(alertController, animated: true, completion: nil)
//            return
//        }
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
                // Handle success case
            case .failure(let error):
                print("Error updating user info: \(error.localizedDescription)")
                // Handle error case, e.g. display error alert to user
            }
        }
    }
    

}
