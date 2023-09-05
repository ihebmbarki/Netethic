//
//  wizardStepViewController.swift
//  4INSHIELD
//
//  Created by kaisensData on 9/8/2023.
//

import UIKit
import Alamofire
import FlexibleSteppedProgressBar

class wizardStepViewController: UIViewController, FlexibleSteppedProgressBarDelegate {

    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var footer: UILabel!
    @IBOutlet weak var dashboardButton: UIButton!
    @IBOutlet weak var merciLabel: UILabel!
    @IBOutlet weak var changeLangageButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
//    @IBOutlet weak var mainView: FooterView!{
//        didSet{
//            mainView.configure(titleText: "© 2023 Tous Droits Réservés Réalisé par Data4Ethic", color: UIColor(named: "AccentColor") ?? .white)
//        }
//    }
    var progressBar: FlexibleSteppedProgressBar!
    var progressBarWithoutLastState: FlexibleSteppedProgressBar!
    var progressBarWithDifferentDimensions: FlexibleSteppedProgressBar!
    
    var backgroundColor = UIColor(named: "AccentColor")
    var progressColor = UIColor(named: "AccentColor")
    var textColorHere = UIColor.white
    var maxIndex = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        if  SharedVariables.shared.wizzard != 6{
            setupProgressBarWithDifferentDimensions()
        }
        // Do any additional setup after loading the view.
        dashboardButton.setupBorderBtn()
        dashboardButton.applyGradient()
        dashboardButton.layer.borderWidth = 5
        dashboardButton.layer.borderColor = UIColor.systemGray5.cgColor
        dashboardButton.layer.shadowColor = UIColor.systemGray5.cgColor // Shadow color
        dashboardButton.layer.shadowOffset = CGSize(width: 0, height: 2) // Shadow offset
        dashboardButton.layer.shadowOpacity = 0.5 // Shadow opacity
        dashboardButton.layer.shadowRadius = 4 // Shadow radius
        dashboardButton.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 28)
        dashboardButton.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 28)
            
        updateLocalizedStrings()

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
            constant: 180
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
        progressBarWithDifferentDimensions.completedTillIndex = 4
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
                changeLangageButton.setImage(UIImage(named: "fr_white"), for: .normal)
            } else if selectedLanguage == "en" {
                changeLangageButton.setImage(UIImage(named: "eng_white"), for: .normal)
            }
        }
    }
    func updateLocalizedStrings() {
        let bundle = Bundle.main.path(forResource: LanguageManager.shared.currentLanguage, ofType: "lproj").flatMap(Bundle.init) ?? Bundle.main

        if LanguageManager.shared.currentLanguage == "fr" {
            merciLabel.text = "Merci pour votre confiance "
//            mainView.configure(titleText: "© 2023 Tous Droits Réservés Réalisé par Data4Ethic", color: UIColor(named: "AccentColor") ?? .white)
            self.dashboardButton.setTitle("Aller au tableau de board", for: .normal)
        }
        if LanguageManager.shared.currentLanguage == "en" {
            merciLabel.text = "Thank you for placing your trust in us "
            self.dashboardButton.setTitle("Go to dashboard ", for: .normal)
//            mainView.configure(titleText: "© 2023 All Rights Reserved Made by Data4Ethic", color: UIColor(named: "AccentColor") ?? .white)
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
                    self.changeLangageButton.setImage(UIImage(named: "eng_white1"), for: .normal)
                } else if action.title == "Français" {
                    LanguageManager.shared.currentLanguage = "fr"
                    UserDefaults.standard.set("fr", forKey: "selectedLanguage")
                    self.changeLangageButton.setImage(UIImage(named: "fr_white1"), for: .normal)
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
    
    @IBAction func backButton(_ sender: Any) {
//        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func changeLangageButton(_ sender: Any) {
        translate()
    }
    @IBAction func dashboardButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Children", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChildrenListSB")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}
