//
//  OpenHomeViewController.swift
//  4INSHIELD
//
//  Created by kaisensData on 28/8/2023.
//

import UIKit

class OpenHomeViewController: UIViewController {

//    @IBOutlet weak var mainView: FooterView!{
//        didSet{
//            mainView.configure(titleText: "© 2023 Tous Droits Réservés Réalisé par Data4Ethic", color: UIColor(named: "AccentColor") ?? .white)
//        }
//    }
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
                scrollView.contentInsetAdjustmentBehavior = .never
        }
    }
    @IBOutlet weak var secondeLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var InscriptionLabel: UILabel!
    @IBOutlet weak var BienvenueLabel: UILabel!
    @IBOutlet weak var changeLangageButton: UIButton!
    @IBOutlet weak var connexionButton: UIButton!{
        didSet{
            connexionButton.setupBorderBtn()
            connexionButton.applyGradient()
        }
    }
    @IBOutlet weak var inscriptionButton: UIButton!{
        didSet{
            inscriptionButton.setupBorderBtn()
            inscriptionButton.applyGradient()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LanguageManager.shared.currentLanguage = "fr"
        updateLocalizedStrings()
    }
    
    func goToScreen(withId identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: identifier)
        navigationController?.pushViewController(VC, animated: true)
//        VC.modalPresentationStyle = .overFullScreen
//        self.present(VC, animated: true, completion: nil)

    }
    func updateLocalizedStrings() {
        let bundle = Bundle.main.path(forResource: LanguageManager.shared.currentLanguage, ofType: "lproj").flatMap(Bundle.init) ?? Bundle.main
            if LanguageManager.shared.currentLanguage == "fr"{
//            mainView.configure(titleText: "© 2023 Tous Droits Réservés Réalisé par Data4Ethic", color: UIColor(named: "AccentColor") ?? .white)
            BienvenueLabel.text = NSLocalizedString("Bienvenue sur netethic", tableName: nil, bundle: bundle, value: "", comment: "")
            InscriptionLabel.text = NSLocalizedString("Inscrivez-vous ou connectez-vous pour continuer", tableName: nil, bundle: bundle, value: "", comment: "")
                let text = NSLocalizedString("L'application netethic veille au bien-être des enfants et des adolescents dans l'espace numérique.", tableName: nil, bundle: Bundle.main, value: "", comment: "")

                 let attributedString = NSMutableAttributedString(string: text)

                 if let boldFont = UIFont.boldSystemFont(ofSize: firstLabel.font.pointSize) as UIFont? {
                     let range = (text as NSString).range(of: "netethic")
                     attributedString.addAttribute(.font, value: boldFont, range: range)
                 }
                 firstLabel.attributedText = attributedString
                
            secondeLabel.text = NSLocalizedString("Inscrivez-vous dès maintenant pour accéder à un outil de protection complet et facile à utiliser pour vous et vos enfants.", tableName: nil, bundle: bundle, value: "", comment: "")
           
            inscriptionButton.setTitle(NSLocalizedString("Inscription", tableName: nil, bundle: bundle, value: "", comment: ""), for: .normal)
            connexionButton.setTitle(NSLocalizedString("Connexion", tableName: nil, bundle: bundle, value: "", comment: ""), for: .normal)
        }
        if LanguageManager.shared.currentLanguage == "en"{
//            mainView.configure(titleText: "© 2023 All Rights Reserved Made by Data4Ethic", color: UIColor(named: "AccentColor") ?? .white)
            BienvenueLabel.text = NSLocalizedString("Welcome to netethic", tableName: nil, bundle: bundle, value: "", comment: "")
            InscriptionLabel.text = NSLocalizedString("Register or sign in to continue", tableName: nil, bundle: bundle, value: "", comment: "")
           
            let text = NSLocalizedString("The netethic application ensures the well-being of children and adolescents in the digital space.", tableName: nil, bundle: Bundle.main, value: "", comment: "")

            let attributedString = NSMutableAttributedString(string: text)

            let boldFont = UIFont.boldSystemFont(ofSize: firstLabel.font.pointSize)
            let range = (text as NSString).range(of: "netethic")
            attributedString.addAttribute(.font, value: boldFont, range: range)

            firstLabel.attributedText = attributedString
            
            secondeLabel.text = NSLocalizedString("Sign up now for a comprehensive and easy-to-use protection tool for you and your children.", tableName: nil, bundle: bundle, value: "", comment: "")
           
            inscriptionButton.setTitle(NSLocalizedString("Sign Up", tableName: nil, bundle: bundle, value: "", comment: ""), for: .normal)
            connexionButton.setTitle(NSLocalizedString("Sign In", tableName: nil, bundle: bundle, value: "", comment: ""), for: .normal)
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
    @IBAction func changeLangageButton(_ sender: Any) {
        translate()
        print("langue")
    }
    
    @IBAction func inscriptionButton(_ sender: Any) {
        goToScreen(withId: "Register")
    }
    
    @IBAction func connexionButton(_ sender: Any) {
        goToScreen(withId: "signIn")
    }
}
