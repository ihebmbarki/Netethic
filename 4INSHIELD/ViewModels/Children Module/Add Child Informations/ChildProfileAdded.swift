import Foundation
import UIKit
import FLAnimatedImage
import Alamofire
import FlexibleSteppedProgressBar

class ChildProfileAdded: UIViewController, FlexibleSteppedProgressBarDelegate {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var felicitationLabel: UILabel!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var gifImageView: FLAnimatedImageView!
    @IBOutlet weak var addNewProfileBtn: UIButton!
    @IBOutlet weak var editProfileInfoBtn: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var changeLanguageButton: UIButton!
    
    @IBOutlet weak var mainView: FooterView!{
        didSet{
            mainView.configure(titleText: "© 2023 Tous Droits Réservés Réalisé par Data4Ethic", color: UIColor(named: "AccentColor") ?? .white)
        }
    }
    
    @IBOutlet weak var footer: UILabel!
    var progressBar: FlexibleSteppedProgressBar!
    var progressBarWithoutLastState: FlexibleSteppedProgressBar!
    var progressBarWithDifferentDimensions: FlexibleSteppedProgressBar!
    
    var backgroundColor = UIColor(named: "AccentColor")
    var progressColor = UIColor(named: "AccentColor")
    var textColorHere = UIColor.white
    var maxIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //appel Progressbar
        if  SharedVariables.shared.wizzard != 6{
            setupProgressBarWithDifferentDimensions()
        }
        // Do any additional setup after loading the view.
        continueButton.setupBorderBtn()
        continueButton.applyGradient()
        addNewProfileBtn.setupBorderBtn()
        continueButton.applyGradient()
        continueButton.layer.borderWidth = 5
        continueButton.layer.borderColor = UIColor.white.cgColor
        continueButton.layer.shadowColor = UIColor.gray.cgColor // Shadow color
        continueButton.layer.shadowOffset = CGSize(width: 0, height: 2) // Shadow offset
        continueButton.layer.shadowOpacity = 0.5 // Shadow opacity
        continueButton.layer.shadowRadius = 4 // Shadow radius
        continueButton.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 22)
        addNewProfileBtn.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 22)
            
        updateLocalizedStrings()

        
        // Load the GIF file from the main bundle
        guard let url = Bundle.main.url(forResource: "Succes", withExtension: "gif") else {
            return
        }
        
        // Create an animated image object with the GIF file data
        guard let data = try? Data(contentsOf: url), let animatedImage = FLAnimatedImage(animatedGIFData: data) else {
            return
        }
        
        // Set the animated image to your UIImageView
        gifImageView.animatedImage = animatedImage
        
        //Buttons style
        addNewProfileBtn.applyGradient()
//        editProfileInfoBtn.applyGradient()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LanguageManager.shared.currentLanguage = "fr"
        updateLocalizedStrings()
    }
    
    
    func setupProgressBarWithDifferentDimensions() {
        progressBarWithDifferentDimensions = FlexibleSteppedProgressBar()
        progressBarWithDifferentDimensions.translatesAutoresizingMaskIntoConstraints = false
        self.progressBarView.addSubview(progressBarWithDifferentDimensions)
        
        // iOS9+ auto layout code
        let horizontalConstraint = progressBarWithDifferentDimensions.centerXAnchor.constraint(equalTo: self.progressBarView.centerXAnchor)
        let verticalConstraint = progressBarWithDifferentDimensions.topAnchor.constraint(
            equalTo: progressBarView.topAnchor,
            constant: 152
        )
        let widthConstraint = progressBarWithDifferentDimensions.widthAnchor.constraint(equalToConstant: 300)
        let heightConstraint = progressBarWithDifferentDimensions.heightAnchor.constraint(equalToConstant: 150)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        progressBarWithDifferentDimensions.numberOfPoints = 5
        progressBarWithDifferentDimensions.lineHeight = 6
        progressBarWithDifferentDimensions.radius = 14
        progressBarWithDifferentDimensions.progressRadius = 14
        progressBarWithDifferentDimensions.progressLineHeight = 6
        progressBarWithDifferentDimensions.delegate = self
        progressBarWithDifferentDimensions.useLastState = true
        progressBarWithDifferentDimensions.lastStateCenterColor = progressColor
        progressBarWithDifferentDimensions.selectedBackgoundColor = progressColor ?? .blue
        progressBarWithDifferentDimensions.selectedOuterCircleStrokeColor = backgroundColor
        progressBarWithDifferentDimensions.lastStateOuterCircleStrokeColor = backgroundColor
        progressBarWithDifferentDimensions.currentSelectedCenterColor = progressColor ?? .blue
        progressBarWithDifferentDimensions.stepTextColor = textColorHere
        progressBarWithDifferentDimensions.currentSelectedTextColor = progressColor
        progressBarWithDifferentDimensions.completedTillIndex = 3
    }
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        if progressBar == self.progressBar || progressBar == self.progressBarWithoutLastState {
        } else if progressBar == progressBarWithDifferentDimensions {
            if position == FlexibleSteppedProgressBarTextLocation.center {
                switch index {
                    
                case 0: return "1"
                case 1: return "2"
                case 2: return "3"
                case 3: return "4"
                case 4: return "5"
                default: return "Date"
                    
                }
            }
        }
        return ""
    }
    
 
    func updateLanguageButtonImage() {
        if let selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
            if selectedLanguage == "fr" {
                changeLanguageButton.setImage(UIImage(named: "fr_white"), for: .normal)
            } else if selectedLanguage == "en" {
                changeLanguageButton.setImage(UIImage(named: "eng_white"), for: .normal)
            }
        }
    }
    func updateLocalizedStrings() {
        let bundle = Bundle.main.path(forResource: LanguageManager.shared.currentLanguage, ofType: "lproj").flatMap(Bundle.init) ?? Bundle.main

        if LanguageManager.shared.currentLanguage == "fr" {
            felicitationLabel.text = "Félicitations!"
            textLabel.text = "Vous avez complété avec succès le profil de votre enfant. "
            mainView.configure(titleText: "© 2023 Tous Droits Réservés Réalisé par Data4Ethic", color: UIColor(named: "AccentColor") ?? .white)
         
            self.continueButton.setTitle("Continuer", for: .normal)
            self.addNewProfileBtn.setTitle("Ajouter un autre enfant", for: .normal)
        }
        if LanguageManager.shared.currentLanguage == "en" {
            felicitationLabel.text = "Congratulations!"
            textLabel.text = "You have successfully completed your child's profile."
            mainView.configure(titleText: "© 2023 All Rights Reserved Made by Data4Ethic", color: UIColor(named: "AccentColor") ?? .white)
            
            self.continueButton.setTitle("Continue", for: .normal)
            self.addNewProfileBtn.setTitle("Add another child ", for: .normal)
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
                    self.changeLanguageButton.setImage(UIImage(named: "eng_white1"), for: .normal)
                } else if action.title == "Français" {
                    LanguageManager.shared.currentLanguage = "fr"
                    UserDefaults.standard.set("fr", forKey: "selectedLanguage")
                    self.changeLanguageButton.setImage(UIImage(named: "fr_white1"), for: .normal)
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
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
        let wizardParam = Wizard(user: userID, wizardStep: 5, platform: "mobile", date: dateString)
     
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
                            SharedVariables.shared.wizzard = 5
                            print("save!!!!!")
                        } catch let error {
                            /// Handle json decode error
                            print(error)
                        }
                    case 401:
                        /// Handle 401 error
                        if LanguageManager.shared.currentLanguage == "fr"{
        
                            self.showAlert(title:"Alerte" ,message: "Désolé, qulque chose s'est mal passé.   ")
                        }
                        if LanguageManager.shared.currentLanguage == "en"{
                            self.showAlert(title: "Alert", message: "Sorry, something went wrong.")
                        }
                        print("not authorization")
                    default:
                        /// Handle unknown error
                        print("we ran into error")
                    }
                case .failure(let error):
                    /// Handle request failure
                    if LanguageManager.shared.currentLanguage == "fr"{
                        self.showAlert(title:"Alerte" ,message: "Désolé, qulque chose s'est mal passé.   ")
                    }
                    if LanguageManager.shared.currentLanguage == "en"{
                        self.showAlert(title: "Alert", message: "Sorry, something went wrong.")
                    }
                }
            })
    }

    @IBAction func addChildButton(_ sender: Any) {
        print("add")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "childInfos")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
//        navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func changeLangageButton(_ sender: Any) {
        translate()
        print("fren")
      
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continuebutton(_ sender: Any) {
        if  SharedVariables.shared.wizzard != 6{
            platform()
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "wizardStepViewController")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
}
