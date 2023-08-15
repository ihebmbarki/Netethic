//
//  ChildDevice.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 23/3/2023.
//
import Foundation
import Alamofire
import UIKit

class ChildDevice: UIViewController {

    @IBOutlet weak var firstInformationLabel: UILabel!
    
    @IBOutlet weak var etapeLabel: UILabel!
    @IBOutlet weak var passerButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var ChangeLangageButton: UIButton!
    @IBOutlet weak var ajoutDeviceLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        etapeLabel.text = "Veuillez suivre les étapes suivantes:\n\n\n1. Prenez le téléphone portable de votre enfant\n2.  Scannez ce code QR avec l'appareil photo de l'appareil de votre enfant. \n3. Vous serez redirigé vers la page de téléchargement de l'application NETETHIC. \n4. Une fois l'application est installée, connectez-vous ! \n5. Confirmez que le téléphone va être utilisé par un enfant"
        ajoutDeviceLabel.font =  UIFont.boldSystemFont(ofSize: 22) 
        updateLocalizedStrings()
        
        //Buttons style
        passerButton.applyGradient()
        nextButton.applyGradient()
        passerButton.setupBorderBtn()
        nextButton.setupBorderBtn()
        passerButton.layer.borderWidth = 1
        passerButton.layer.borderColor = UIColor.white.cgColor

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LanguageManager.shared.currentLanguage = "fr"
        updateLocalizedStrings()
    }
    
    func updateLanguageButtonImage() {
        if let selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
            if selectedLanguage == "fr" {
                ChangeLangageButton.setImage(UIImage(named: "fr_white"), for: .normal)
            } else if selectedLanguage == "en" {
                ChangeLangageButton.setImage(UIImage(named: "eng_white"), for: .normal)
            }
        }
    }
    
    func updateLocalizedStrings() {
        let bundle = Bundle.main.path(forResource: LanguageManager.shared.currentLanguage, ofType: "lproj").flatMap(Bundle.init) ?? Bundle.main

        if LanguageManager.shared.currentLanguage == "fr" {
            ajoutDeviceLabel.text = "Veuillez ajouter les appareils de votre enfant"
            firstInformationLabel.text = "Les informations fournies par l'appareil de votre enfant vous aideront à surveiller sa santé mentale, la qualité de son sommeil, sa localisation, et les applications qui l'intéressent, etc."
            etapeLabel.text = "Veuillez suivre les étapes suivantes:\n\n\n1. Prenez le téléphone portable de votre enfant\n2.  Scannez ce code QR avec l'appareil photo de l'appareil de votre enfant. \n3. Vous serez redirigé vers la page de téléchargement de l'application NETETHIC. \n4. Une fois l'application est installée, connectez-vous ! \n5. Confirmez que le téléphone va être utilisé par un enfant"
            self.nextButton.setTitle("Suivant", for: .normal)
            self.passerButton.setTitle("Passer", for: .normal)
        }
        if LanguageManager.shared.currentLanguage == "en" {
            ajoutDeviceLabel.text = "Please add your child’s devices"
            firstInformationLabel.text = "The information from your child's device will help you monitor their mental health, sleep quality, whereabouts, and apps of interest, etc. "
            
            etapeLabel.text = "Please follow the next steps:\n\n\n1. Grab your child's smartphone\n2. Scan this QR code with your child’s device camera\n3. You will be redirected to the NETETHIC app download page\n4. Once the app is installed, simply log in\n5. Confirm that the device will be used by a child "
            self.nextButton.setTitle("Next", for: .normal)
            self.passerButton.setTitle("Skip", for: .normal)
        }
    }
    func translate() {
        let languages = ["English", "Français"]
        let languageAlert = UIAlertController(title: "Choisir la langue", message: nil, preferredStyle: .actionSheet)
        
        for language in languages {
            let action = UIAlertAction(title: language, style: .default) { action in
                if action.title == "English" {
                    LanguageManager.shared.currentLanguage = "en"
                    UserDefaults.standard.set("en", forKey: "selectedLanguage")
                    self.ChangeLangageButton.setImage(UIImage(named: "eng_white1"), for: .normal)
                } else if action.title == "Français" {
                    LanguageManager.shared.currentLanguage = "fr"
                    UserDefaults.standard.set("fr", forKey: "selectedLanguage")
                    self.ChangeLangageButton.setImage(UIImage(named: "fr_white1"), for: .normal)
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
    
    func platform(){
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateString = df.string(from: date)
        
        
        guard let userIDString = UserDefaults.standard.string(forKey: "userID"),
              let userID = Int(userIDString) else {
            print("User ID not found")
            return
        }
        let wizardParam = Wizard(user: userID, wizardStep: 4, platform: "mobile", date: dateString)
        AF.request(user_journey_url, method: .post, parameters: wizardParam, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<500)
            .responseJSON(completionHandler: { (response) in
                
                debugPrint(response)
                switch response.result {
                case .success(let data):
                    switch response.response?.statusCode {
                    case 200,201:
                        /// Handle success, parse JSON data
                        do {
                            let jsonData = try JSONDecoder().decode(WizardResponse.self, from: JSONSerialization.data(withJSONObject: data))
                            
                            print("save!!!!!")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "ChildProfileAdded")
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: true, completion: nil)
                        } catch let error {
                            /// Handle json decode error
                            print(error)
                        }
                    case 401:
                        /// Handle 401 error
                        print("not authorization")
                    default:
                        /// Handle unknown error
                        print("we ran into error")
                    }
                case .failure(let error):
                    /// Handle request failure
                    print(error.localizedDescription)
                }
            })
    }

    @IBAction func changeLanguageButton(_ sender: Any) {
        translate()
       
    }
    
    @IBAction func passerButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChildProfileAdded")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
//        navigationController?.pushViewController(vc, animated: true)

        
    }
    @IBAction func nextButton(_ sender: Any) {
       platform()
        }
}
